<title>Sanal Makine Oluştur</title>

<?php 
$MikroServis_Dizini = "C:/AppServ/www/VmwareManager_Github/VM_MicroService";

$Network_NM = "255.255.255.0";	//Network NETMASK
$Network_GW = "192.168.1.1";	//Network Gateway

//vCenter Bilgileri
$vcenter_url ="cloud.example.com"; //ip or url
$vcenter_user="administrator@vsphere.local";
$vcenter_pass="123123";
$cluster ="ESX5_5"; //NEW Datacenter

?>
<form method="post">
	<label>Müşteri ID</label> <input type="text" name="txt_musterid" value="1"><br>
	<label>İşletim Sistemi</label>
	<select name="txt_isletim_sistemi">
		<option value="centos">Centos7 x64</option>
		<option value="ubuntu">Ubuntu 16.04 x64</option>
		<option value="windows2008">Windows 2008 R2 x64</option>
		<option value="windows2012">Windows 2012</option>
	</select>
	<br>
	<label>IP</label>
	<select name="txt_vds_ip">
		<option value="192.168.1.5">192.168.1.5</option>
		<option value="192.168.1.6">192.168.1.6</option>
	</select>
	<br>
	<label>CPU</label> <input type="text" name="txt_cpu" value="1"><br>
	<label>Cores Per Socket</label> <input type="text" name="txt_CoresPerSocket" value="1"><br>
	<label>RAM</label> <input type="text" name="txt_ram" value="1">GB<br>
	<label>HDD</label> <input type="text" name="txt_disk" value="30">GB<br>
	<label>HDD Format</label> <input type="text" name="txt_disk_format" value="Thin"><br>
	
	<input type="submit" name="SunucuOlustur" value="Sunucu Oluştur">
</form>


<?php 

if(isset( $_POST['SunucuOlustur'] ))
{
	$txt_musterid=$_POST['txt_musterid'];
	$txt_isletim_sistemi=$_POST['txt_isletim_sistemi'];
	$txt_vds_ip=$_POST['txt_vds_ip'];
	$txt_clone_name = $txt_vds_ip."_".$txt_musterid;
	$txt_cpu=$_POST['txt_cpu'];
	$txt_ram=$_POST['txt_ram'];
	$txt_disk=$_POST['txt_disk'];
	$txt_disk_format=$_POST['txt_disk_format'];
	$txt_CoresPerSocket=$_POST['txt_CoresPerSocket'];
	

	switch ($txt_isletim_sistemi) 
	{
		case 'centos':
		//Network Ayarı için | Clon alınan makine'nin giriş bilgileri
		$g_username="root";					//Klon Makine kullanıcı adı
		$g_password="123QWEqwe";			//Klon Makine Şifre
		$ClonName = "centos";				//Klon alınacak makine adı
		$network_filepath = "/etc/sysconfig/network-scripts/ifcfg-ens160";		//Klon Makine network yolu
		break;

		case'ubuntu':	
		//Network Ayarı için | Clon alınan makine'nin giriş bilgileri
		$g_username="root";					//Klon Makine kullanıcı adı
		$g_password="123QWEqwe";			//Klon Makine Şifre
		$ClonName = "ubuntu";				//Klon alınacak makine adı
		$network_filepath = "/etc/network/interfaces";				//Klon Makine network yolu
		break;

		case'windows2008':	
		//Network Ayarı için | Clon alınan makine'nin giriş bilgileri
		$g_username="administrator";		//Klon Makine kullanıcı adı
		$g_password="123QWEqwe";			//Klon Makine Şifre
		$ClonName = "Win2008r2";			//Klon alınacak makine adı
		$network_filepath = "YOK";
		break;

		case'windows2012':	
		//Network Ayarı için | Clon alınan makine'nin giriş bilgileri
		$g_username="administrator";		//Klon Makine kullanıcı adı
		$g_password="123QWEqwe";			//Klon Makine Şifre
		$ClonName = "Win2012r2";			//Klon alınacak makine adı
		$network_filepath = "YOK";			//Klon Makine network yolu
		break;

		default:
			echo "Geçersiz bir işletim sistemi seçildi";
			exit();
		break;
	}

	echo "Makine Var ise sil<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service1.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password '.$g_password.' ');
	echo "</pre>";

	echo "Makine olusturuluyor<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service2.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password '.$g_password.'');
	echo "</pre>";

	echo "Esxi template kaydi olusturuluyor<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service3.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password  '.$g_password.'');
	echo "</pre>";

	echo "Disk Tekrar ayarlaniyor<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service4.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password '.$g_password.'');
	echo "</pre>";

	echo "Sunucu baslatiliyor ve vmware tools yukleniyor<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service5.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password '.$g_password.'');
	echo "</pre>";

	echo "Network Ayarlamalari Yapiliyor<hr>";
	echo "<pre>";
	echo Shell_Exec('powershell -InputFormat none -ExecutionPolicy ByPass -NoProfile -Command "'.$MikroServis_Dizini.'/Service6.ps1 -vcenter '.$vcenter_url.' -vcenter_user '.$vcenter_user.' -vcenter_pass '.$vcenter_pass.' -cluster '.$cluster.' -clone_name '.$txt_clone_name.' -NumCpu '.$txt_cpu.' -CoresPerSocket '.$txt_CoresPerSocket.' -MemoryGB '.$txt_ram.' -CapacityGB '.$txt_disk.' -StorageFormat '.$txt_disk_format.' -VDS_ip '.$txt_vds_ip.' -VDS_gateway '.$Network_GW.' -VDS_netmask '.$Network_NM.' -filepath '.$network_filepath.' -hedef_clon '.$ClonName.' -isletim_sistemi '.$txt_isletim_sistemi.' -guest_username '.$g_username.' -guest_password '.$g_password.'');
	echo "</pre>";

}

?>