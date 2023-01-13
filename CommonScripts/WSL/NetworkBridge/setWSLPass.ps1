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

# 首先随意执行一条wsl指令，确保wsl启动，这样后续步骤才会出现WSL网络
Write-Output "check the wsl whether it is running..."
wsl --cd ~ -e ls

# 获取网卡信息
Write-Output "get network card infomation..."
Get-NetAdapter 

# 注意这里，这里是把wsl的虚拟网卡 [WSL] 桥接到我们主机网卡 [以太网]，如果你想桥接到 wifi网卡那应该做相应的调整
Write-Output "Bridging WSL network to Ethernet..."
Set-VMSwitch WSL -NetAdapterName 以太网
# Set-VMSwitch WSL -NetAdapterName "Wi-Fi 2"
Write-Output "`n Modifying WSL network configuration..."

# 这里会去运行我们wsl中的一个网络配置脚本，记得改用户名！
wsl --cd ~ -e sh -c /home/<Your user name>/setWSLPass.sh
Write-Output "`ndone!!!"
pause
