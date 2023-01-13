# 检查并以管理员身份运行PS并带上参数
$currentWi = [Security.Principal.WindowsIdentity]::GetCurrent()
$currentWp = [Security.Principal.WindowsPrincipal]$currentWi

if( -not $currentWp.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator))
{
    $boundPara = ($MyInvocation.BoundParameters.Keys | ForEach-Object{'-{0} {1}' -f  $_ ,$MyInvocation.BoundParameters[$_]} ) -join ' '

    $currentFile = $MyInvocation.MyCommand.Definition

    $fullPara = $boundPara + ' ' + $args -join ' '

    Start-Process "$psHome\powershell.exe"   -ArgumentList "$currentFile $fullPara"   -verb runas

    return
}

echo "Unbridge Network..."
Set-VMSwitch WSL -SwitchType Internal
echo "reboot wsl..."
wsl --shutdown
wsl --cd ~ -e ls
echo "`ndone"
pause
