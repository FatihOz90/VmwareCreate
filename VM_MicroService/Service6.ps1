PARAM 
(
	#Vcenter Ayarlari
	#################################################
	[Parameter(Mandatory=$True)][String]$vcenter,
	[Parameter(Mandatory=$True)][String]$vcenter_user,
	[Parameter(Mandatory=$True)][String]$vcenter_pass,
	[Parameter(Mandatory=$True)][String]$cluster,
	#Kurulacak sunucu ayari ve ip atama
	#################################################
	[Parameter(Mandatory=$True)][String]$clone_name,
	[Parameter(Mandatory=$True)][String]$NumCpu,
	[Parameter(Mandatory=$True)][String]$CoresPerSocket,
	[Parameter(Mandatory=$True)][String]$MemoryGB,
	[Parameter(Mandatory=$True)][String]$CapacityGB,
	[Parameter(Mandatory=$True)][String]$StorageFormat,
	[Parameter(Mandatory=$True)][String]$VDS_ip,
	[Parameter(Mandatory=$True)][String]$VDS_gateway,
	[Parameter(Mandatory=$True)][String]$VDS_netmask,
	[Parameter(Mandatory=$True)][String]$filepath,
	#Klon Makine Bilgisi
	#################################################
	[Parameter(Mandatory=$True)][String]$hedef_clon,
	[Parameter(Mandatory=$True)][String]$isletim_sistemi,
	[Parameter(Mandatory=$True)][String]$guest_username,
	[Parameter(Mandatory=$True)][String]$guest_password
)
#################################################
#Vcenter Baglanti && Kutuphane
#################################################
#Import-Module VMware.VimAutomation.Core
#Set-PowerCLIConfiguration -InvalidCertificateAction ignore -confirm:$false
Connect-VIServer $vcenter -User $vcenter_user -Pass  $vcenter_pass
#################################################
$cluster = Get-Cluster | where {$_.name -eq $cluster}


$clones = Get-VM -Location $cluster -Name "$clone_name"
if(($clones.PowerState -eq "PoweredOn"))
{
	if($isletim_sistemi -eq "centos")
	{
		#Write-Host "Centos -> Sunucu ($clone_name) atanmasi icin islem baslatiliyor"
		Invoke-VMscript -VM "$clone_name" -Scripttext "service network stop" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
		#Write-Host " IP atanmasi ayarlaniyor."
		Invoke-VMscript -VM "$clone_name" -ScriptText "touch $filepath; chmod 777 $filepath" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
		Invoke-VMscript -VM "$clone_name" -ScriptText "echo -e 	NAME=ens160'\n'TYPE=Ethernet'\n'BOOTPROTO=static'\n'DEFROUTE=yes'\n'PEERDNS=yes'\n'PEERROUTERS=yes'\n'IPV4_FAILURE_FATAL=no'\n'ONBOOT=yes'\n'IPADDR=$VDS_ip'\n'NETMASK=$VDS_netmask'\n'GATEWAY=$VDS_gateway > $filepath" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
		#Write-Host "Sunucu Yeniden baslatiliyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "reboot" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
	}

	if($isletim_sistemi -eq "windows2008")
	{
		$ethernet_ip = "netsh interface ipv4 set address name=""Local Area Connection"" static $VDS_ip $VDS_netmask $VDS_gateway"
		$DNS_ip = "netsh interface ipv4 set dns name=""Local Area Connection"" static 8.8.8.8"
		#Write-Host "Windows -> Sunucu Network Ayarlaniyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "echo $ethernet_ip > C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		Invoke-VMscript -VM "$clone_name" -ScriptText "C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		#Write-Host " IP atanmasi yapildi. DNS Ataniyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "echo $DNS_ip > C:\dns_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		Invoke-VMscript -VM "$clone_name" -ScriptText "C:\dns_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		#Write-Host " DNS atanmasi yapildi."
		Invoke-VMscript -VM "$clone_name" -Scripttext "del C:\dns_ata.bat; del C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
	}
	
	if($isletim_sistemi -eq "windows2012")
	{
		$ethernet_ip = "netsh interface ipv4 set address name=""Local Area Connection"" static $VDS_ip $VDS_netmask $VDS_gateway"
		$DNS_ip = "netsh interface ipv4 set dns name=""Local Area Connection"" static 8.8.8.8"
		#Write-Host "Windows -> Sunucu Network Ayarlaniyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "echo $ethernet_ip > C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		Invoke-VMscript -VM "$clone_name" -ScriptText "C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		#Write-Host " IP atanmasi yapildi. DNS Ataniyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "echo $DNS_ip > C:\dns_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		Invoke-VMscript -VM "$clone_name" -ScriptText "C:\dns_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
		#Write-Host " DNS atanmasi yapildi."
		Invoke-VMscript -VM "$clone_name" -Scripttext "del C:\dns_ata.bat; del C:\ip_ata.bat" -GuestUser $guest_username -GuestPassword $guest_password -scriptType Bat | Out-Null
	}
	
	if($isletim_sistemi -eq "ubuntu")
	{
		$stream.WriteLine("Ubuntu -> Sunucu IP atanmasi icin islem baslatiliyor.")
		#Write-Host "Ubuntu -> Sunucu IP atanmasi icin islem baslatiliyor."
		Invoke-VMscript -VM "$clone_name" -ScriptText "echo -e 	source /etc/network/interfaces.d/*'\n'auto lo '\n'iface lo inet loopback'\n'auto ens32'\n'iface ens32 inet static'\n'address $VDS_ip'\n'gateway $VDS_gateway'\n'netmask $VDS_netmask'\n'dns-nameservers 4.2.2.4'\n'dns-search google.com > $filepath" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
		$stream.WriteLine("Ubuntu -> Sunucu Yeniden baslatiliyor.")
		#Write-Host "Sunucu Yeniden baslatiliyor."
		Invoke-VMscript -VM "$clone_name" -Scripttext "reboot" -GuestUser $guest_username -GuestPassword $guest_password -scriptType bash | Out-Null
	}

}

Write-Host "OK!"
Disconnect-VIServer $vcenter -Confirm:$false | Out-Null
#Write-Host "vCenter disconnected"