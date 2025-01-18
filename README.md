# HomeDDNS
Shell Script Home DDNS (BIND9 nsupdate)

Script นี้รองรับทั้ง IPv4 และ IPv6

## ตัวอย่างวิธีเพิ่ม TSIG และตั้งกฎบนเครื่องเซิร์ฟเวอร์ DNS
แก้ไขไฟล์ ```/etc/bind/named.conf``` ให้เพิ่ม
```
include "/etc/bind/key/*.key";
```
สร้างไดเรกเทอรีใหม่ที่ ```/etc/bind/key```
```
mkdir -p /etc/bind/key
cd /etc/bind/key
```
สร้าง TSIG key สามารถเลือกอัลกอริทึมได้ตามสะดวก
```
tsig-keygen -a hmac-sha512 myhome.example.net > myhome.example.net.key
cat myhome.example.net.key
```
ตัวอย่าง
```
key "myhome.example.net" {
	algorithm hmac-sha512;
	secret "SFks+U1ZBh1Pd8YpQBPnP+QmafXdLhobwOP2rqtw6lRWoJ69IGoFZpa11fLh040QFvQe8fhaMgNIeXCQfe8EcA==";
};
```
แก้ไขไฟล์ ```/etc/bind/named.conf.local``` ให้เพิ่ม ```update-policy{};``` ```inline-signing yes;``` ใน zone
```
zone "example.net" in {
	. . .
	inline-signing yes;
	update-policy {
		grant myhome.example.net name myhome.example.net. A AAAA;
	};
	
	. . .
};
```
โหลด config ใหม่
```
rndc reconfig
```
## ซอฟต์แวร์ที่ต้องติดตั้งก่อนใช้งานบนเครื่อง Client


ต้องติดตั้ง jq, curl, nsupdate (`bind9-dnsutils` บน Debian, `bind9-next-utils` บน RHEL-based และ `dnsutils` บน Arch Linux) หากติดตั้งไว้แล้วก็สามารถใช้งานได้เลย

เพียงแค่แก้ไขไฟล์ Script ตามคำแนะนำข้างในไฟล์

**อย่าลืมเพิ่มเรคคอร์ดเปล่าก่อนใช้** สามารถแก้ไขได้โดยใช้ ```editName.sh```

## ข้อแนะนำ

ควรใช้คู่กับ ```crontab``` แนะนำให้เรียกใช้งานทุก ๆ 1 นาที หรือ แล้วแต่สะดวก แนะนำให้สอดคล้องกับ TTL
