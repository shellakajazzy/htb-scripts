# Netmon
Notes and script for the [Netmon](https://app.hackthebox.com/machines/Netmon?sort_by=created_at&sort_type=desc) machine.

``` {.bash file=netmon/netmon.sh #netmon.sh}
TARGET_URL="$1"
ATTACK_URL="$2"
```

## Enumeration
Running `nmap` on the Netmon box shows that the following ports are open:
- `21`: FTP
- `80`: HTTP
- `135/139`: NetBIOS
- `445`: SMB
- `5985`: WinRM

From here, we know there is are paths for file traversal through FTP/SMB, as well as a website through HTTP, and a way to access the machine through WinRM.

## User Flag
Logging into the user flag using the `ftp` command, we can follow the tree down to `C:\Users\Public\Desktop` and find the user flag in `user.txt`

``` {.bash #netmon.sh}
rm /tmp/user.txt 2>/dev/null
ftp "ftp://${TARGET_URL}/Users/Public/Desktop/user.txt" -o /tmp/user.txt || exit
printf "\nUser flag is: "
cat /tmp/user.txt
```

## Root Flag
In the same folder we accessed through FTP, we can see that the computer has [PRTG Network Monitor](https://www.paessler.com/prtg/prtg-network-monitor) installed.
Accessing the site hosted on port 80 takes us to a page where we have to find a login name and password for a user.

Through a search, we can see that the configuration files for this program at `/ProgramData/Paessler`.
Here, we can find the creds for a user in `/ProgramData/Paessler/PRTG Network Monitor/` as: `prtgadmin:PrTg@dmin2018`.
We can confirm that the creds work by logging into the monitor through the website on port 80.
However, when we try, we get that the login is invalid.
Incrementing the year in the password to the year the box was released (2019), allows us to login.
Thus, the credentials are `prtgadmin:PrTg@dmin2019`.

We can see that it is running PRTG Network Monitor version `18.1.37.13946`.
This is vulnerable to a [RCE Vulnerability](https://www.infosecmatter.com/metasploit-module-library/?mm=exploit/windows/http/prtg_authenticated_rce).

TODO: implement automating getting a root shell through metasploit (if possible, research needed)
