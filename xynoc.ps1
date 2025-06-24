Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Xynoc Store" Height="520" Width="620" WindowStartupLocation="CenterScreen"
        ResizeMode="NoResize" Background="#1e1e1e" Foreground="White">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock FontSize="24" FontWeight="Bold" Text="Xynoc Store - Installer" Margin="0,0,0,15" HorizontalAlignment="Center"/>

            <CheckBox Name="chrome" Content="Google Chrome" Margin="10"/>
            <CheckBox Name="firefox" Content="Mozilla Firefox" Margin="10"/>
            <CheckBox Name="discord" Content="Discord" Margin="10"/>
            <CheckBox Name="vlc" Content="VLC Media Player" Margin="10"/>

            <ProgressBar Name="progressBar" Height="20" Margin="10,20,10,0" Minimum="0" Maximum="100" Value="0"/>
            <TextBlock Name="statusText" Margin="10,5,10,0" Text="Status: Menunggu aksi..." FontStyle="Italic"/>

            <Button Name="installButton" Content="Install Selected Apps" Height="35" Margin="10,20,10,0" Background="#007acc" Foreground="White"/>
        </StackPanel>
    </Grid>
</Window>
"@

# Load UI
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

# Bind controls
$chrome = $window.FindName("chrome")
$firefox = $window.FindName("firefox")
$discord = $window.FindName("discord")
$vlc = $window.FindName("vlc")
$progressBar = $window.FindName("progressBar")
$statusText = $window.FindName("statusText")
$installButton = $window.FindName("installButton")

# OnClick Install
$installButton.Add_Click({
    $apps = @()
    if ($chrome.IsChecked)  { $apps += @{ Name = "Google Chrome"; ID = "Google.Chrome" } }
    if ($firefox.IsChecked) { $apps += @{ Name = "Mozilla Firefox"; ID = "Mozilla.Firefox" } }
    if ($discord.IsChecked) { $apps += @{ Name = "Discord"; ID = "Discord.Discord" } }
    if ($vlc.IsChecked)     { $apps += @{ Name = "VLC Media Player"; ID = "VideoLAN.VLC" } }

    if ($apps.Count -eq 0) {
        [System.Windows.MessageBox]::Show("Silakan pilih aplikasi untuk diinstal.", "Xynoc Store")
        return
    }

    $progressBar.Maximum = $apps.Count
    $progressBar.Value = 0

    foreach ($app in $apps) {
        $statusText.Text = "Menginstal: $($app.Name)..."
        $window.Dispatcher.Invoke([action]{}, "Background") # Refresh UI

        Start-Process "winget" -ArgumentList "install --id=$($app.ID) --silent -e" -Wait

        $progressBar.Value += 1
    }

    $statusText.Text = "Instalasi selesai!"
    [System.Windows.MessageBox]::Show("Semua aplikasi selesai diinstal.", "Xynoc Store")
})

# Show window
$window.ShowDialog() | Out-Null
