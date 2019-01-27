<%
' This script performs 'RC4' Stream Encryption
' (Based on what is widely thought to be RSA's RC4
' algorithm. It produces output streams that are identical
' to the commercial products)
' This script is Copyright © 1999 by Mike Shaffer
' ALL RIGHTS RESERVED WORLDWIDE
dim PASSPHRASE : PASSPHRASE = "AOPNC178OE_DAODJW-LD984MCOWam03dmlzz7_"
dim sbox(255)
dim key(255)

' called by EnDeCrypt function to initializes the sbox and the key array
sub RC4Initialize(strPwd)
	dim a, b, tempSwap, intLength
	intLength = len(strPwd)
	for a = 0 to 255
		key(a) = asc(mid(strpwd, (a mod intLength)+1, 1))
		sbox(a) = a
	next
	b = 0
	for a = 0 to 255
		b = (b + sbox(a) + key(a)) mod 256
		tempSwap = sbox(a)
		sbox(a) = sbox(b)
		sbox(b) = tempSwap
	next
end sub

 ' This routine does all the work. Call it both to ENcrypt and to DEcrypt your data.
function EnDeCrypt(plaintxt, psw)
	dim a, i, j, k, temp
		dim cipherby, cipher
	i = 0
	j = 0
	RC4Initialize psw
	for a = 1 to len(plaintxt)
		i = (i + 1) mod 256
		j = (j + sbox(i)) mod 256
		temp = sbox(i)
		sbox(i) = sbox(j)
		sbox(j) = temp
		k = sbox((sbox(i) + sbox(j)) mod 256)
		cipherby = Asc(Mid(plaintxt, a, 1)) xor k
		cipher = cipher & Chr(cipherby)
	next
	EnDeCrypt = cipher
end function

function decrypt(data)
	decrypt = EnDeCrypt(data, PASSPHRASE)
end function

function encrypt(data)
	encrypt = EnDeCrypt(data, PASSPHRASE)
end function
%>
