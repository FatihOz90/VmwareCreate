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


#Write-Host "Sunucu baslatiliyor ve vmware tools yukleniyor."
Start-VM $clone_name | Wait-Tools #| Open-VMConsoleWindow

Write-Host "OK!"
#Disconnect-VIServer $vcenter -Confirm:$false | Out-Null
#Write-Host "vCenter disconnected"