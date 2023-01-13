# ��鲢�Թ���Ա�������PS�����ϲ���
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

# ��������ִ��һ��wslָ�ȷ��wsl������������������Ż����WSL����
Write-Output "check the wsl whether it is running..."
wsl --cd ~ -e ls

# ��ȡ������Ϣ
Write-Output "get network card infomation..."
Get-NetAdapter 

# ע����������ǰ�wsl���������� [WSL] �Žӵ������������� [��̫��]����������Žӵ� wifi������Ӧ������Ӧ�ĵ���
Write-Output "Bridging WSL network to Ethernet..."
Set-VMSwitch WSL -NetAdapterName ��̫��
# Set-VMSwitch WSL -NetAdapterName "Wi-Fi 2"
Write-Output "`n Modifying WSL network configuration..."

# �����ȥ��������wsl�е�һ���������ýű����ǵø��û�����
wsl --cd ~ -e sh -c /home/<Your user name>/setWSLPass.sh
Write-Output "`ndone!!!"
pause
