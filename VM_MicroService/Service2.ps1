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
$hosts = Get-VMHost -Location $cluster
$source_vm = Get-VM -Location $cluster | where {$_.name -like $hedef_clon } | Get-View
$clone_folder = $source_vm.parent

$clone_spec = new-object Vmware.Vim.VirtualMachineCloneSpec
$clone_spec.Location = new-object Vmware.Vim.VirtualMachineRelocateSpec
$clone_spec.Location.Transform = [Vmware.Vim.VirtualMachineRelocateTransformation]::sparse #flat Thick #sparse Thin
$clone_spec.Location.DiskMoveType = [Vmware.Vim.VirtualMachineRelocateDiskMoveOptions]::moveAllDiskBackingsAndAllowSharing
$clone_spec.Location.host = $hosts[$i % $hosts.count].Id


#Write-Host "$clone_name makine olusturuluyor."
$source_vm.CloneVM_Task( $clone_folder, $clone_name, $clone_spec ) | Out-Null


#Disconnect-VIServer $vcenter -Confirm:$false | Out-Null
Write-Host "OK!"