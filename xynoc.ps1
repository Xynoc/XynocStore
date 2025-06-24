Add-Type -AssemblyName PresentationFramework

[xml]$xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        Title="Xynoc Store" Height="450" Width="600">
    <Grid Margin="10">
        <StackPanel>
            <TextBlock FontSize="20" FontWeight="Bold" Text="Xynoc Store - Installer"/>
            <CheckBox Name="chrome">Google Chrome</CheckBox>
            <CheckBox Name="firefox">Mozilla Firefox</CheckBox>
            <CheckBox Name="discord">Discord</CheckBox>
            <CheckBox Name="vlc">VLC Media Player</CheckBox>
            <Button Name="installButton" Content="Install Selected Apps" Margin="0,10,0,0"/>
        </StackPanel>
    </Grid>
</Window>
"@

$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$chrome = $window.FindName("chrome")
$firefox = $window.FindName("firefox")
$discord = $window.FindName("discord")
$vlc = $window.FindName("vlc")
$installButton = $window.FindName("installButton")

$installButton.Add_Click({
    if ($chrome.IsChecked) { Start-Process "winget" -ArgumentList "install --id=Google.Chrome -e --silent" }
    if ($firefox.IsChecked) { Start-Process "winget" -ArgumentList "install --id=Mozilla.Firefox -e --silent" }
    if ($discord.IsChecked) { Start-Process "winget" -ArgumentList "install --id=Discord.Discord -e --silent" }
    if ($vlc.IsChecked)     { Start-Process "winget" -ArgumentList "install --id=VideoLAN.VLC -e --silent" }
    [System.Windows.MessageBox]::Show("Installasi Dimulai!", "Xynoc Store")
})

$window.ShowDialog() | Out-Null
