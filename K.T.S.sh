#!/data/data/com.termux/files/usr/bin/bash

echo "Khabam miyad pas age kar nakard narahat nasho"
echo "Dar hal update kardan package ha"
pkg update -y && pkg upgrade -y
pkg install proot-distro -y

echo "In yeki kheyli tool mikeshe ;)"
proot-distro install kali

pkg autoremove -y
echo "Nasb anjam shod dadash"
echo "Har vaght khasti beri to environment Kali in command ro bezan:"
echo "proot-distro login kali"
echo "Bad ke rafti toosh mitooni az package haye apt va chiz haye dige estefade koni"
echo "Har vaght ham khasti biyay biroon bezan 'exit'"
echo "Age bazam komak khazti ya be man payam bede ya boro to wiki proot"