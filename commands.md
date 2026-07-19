# Quick Commands

## Index

1. [Users](#1-users) · 2. [System](#2-system) · 3. [Docker](#3-docker) · 4. [Network](#4-network) · 5. [Files](#5-files) · 6. [Processes](#6-processes) · 7. [Firewall](#7-firewall-ufw) · 8. [Git](#8-git) · 9. [Tar / Zip](#9-tar--zip) · 10. [Text Editing](#10-text-editing)

---

## 1. Users

1.1. **Create user**
```bash
sudo adduser username
```

1.2. **Add to sudo group**
```bash
sudo usermod -aG sudo username
```

1.3. **Create with SSH key**
```bash
sudo useradd -m -s /bin/bash username
sudo mkdir /home/username/.ssh
sudo cp key.pub /home/username/.ssh/authorized_keys
sudo chmod 600 /home/username/.ssh/authorized_keys
sudo chown -R username:username /home/username/.ssh
```

1.4. **Disable root login**
```bash
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

1.5. **Delete user**
```bash
sudo userdel username
```

1.6. **Lock user**
```bash
sudo usermod -L username
```

1.7. **Change user password**
```bash
sudo passwd username
```

1.8. **List all users**
```bash
cat /etc/passwd
```

1.9. **Check user groups**
```bash
groups username
```

1.10. **Switch user**
```bash
su - username
```

---

## 2. System

2.1. **Update packages**
```bash
sudo apt update && sudo apt upgrade -y
```

2.2. **Install package**
```bash
sudo apt install packagename
```

2.3. **Remove package**
```bash
sudo apt remove packagename
```

2.4. **Check disk space**
```bash
df -h
```

2.5. **Check memory**
```bash
free -h
```

2.6. **System info**
```bash
neofetch
```

2.7. **Uptime**
```bash
uptime
```

2.8. **Check OS version**
```bash
cat /etc/os-release
```

2.9. **Check kernel**
```bash
uname -r
```

2.10. **List CPU info**
```bash
lscpu
```

2.11. **List hardware**
```bash
lshw
```

2.12. **Check load average**
```bash
cat /proc/loadavg
```

2.13. **Check mounts**
```bash
mount | column -t
```

2.14. **Edit cron jobs**
```bash
sudo crontab -e
```

2.15. **List cron jobs**
```bash
sudo crontab -l
```

2.16. **Enable service**
```bash
sudo systemctl enable servicename
```

2.17. **Disable service**
```bash
sudo systemctl disable servicename
```

2.18. **Check service status**
```bash
sudo systemctl status servicename
```

2.19. **List running services**
```bash
sudo systemctl list-units --type=service --state=running
```

2.20. **Check last reboot**
```bash
last reboot
```

2.21. **Check failed services**
```bash
sudo systemctl --failed
```

2.22. **View system log**
```bash
sudo journalctl -xe
```

2.23. **View recent logs**
```bash
sudo tail -f /var/log/syslog
```

2.24. **Check hostname**
```bash
hostname
```

2.25. **Set hostname**
```bash
sudo hostnamectl set-hostname newname
```

2.26. **Reboot**
```bash
sudo reboot
```

2.27. **Shutdown**
```bash
sudo shutdown -h now
```

2.28. **Schedule shutdown**
```bash
sudo shutdown -h +60
```

2.29. **Cancel shutdown**
```bash
sudo shutdown -c
```

2.30. **Clear memory cache**
```bash
sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
```

---

## 3. Docker

3.1. **Install Docker**
```bash
curl -fsSL https://get.docker.com | sudo bash
```

3.2. **Add user to docker group**
```bash
sudo usermod -aG docker username
```

3.3. **Start Docker**
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

3.4. **List running containers**
```bash
docker ps
```

3.5. **List all containers**
```bash
docker ps -a
```

3.6. **Run container**
```bash
docker run -it imagename bash
```

3.7. **Run container in background**
```bash
docker run -d imagename
```

3.8. **Map port**
```bash
docker run -d -p 8080:80 imagename
```

3.9. **Stop container**
```bash
docker stop containername
```

3.10. **Start container**
```bash
docker start containername
```

3.11. **Restart container**
```bash
docker restart containername
```

3.12. **Kill container**
```bash
docker kill containername
```

3.13. **Remove container**
```bash
docker rm containername
```

3.14. **View container logs**
```bash
docker logs containername
```

3.15. **Follow container logs**
```bash
docker logs -f containername
```

3.16. **Execute command in container**
```bash
docker exec -it containername bash
```

3.17. **List images**
```bash
docker images
```

3.18. **Pull image**
```bash
docker pull imagename
```

3.19. **Build image**
```bash
docker build -t imagename .
```

3.20. **Remove image**
```bash
docker rmi imagename
```

3.21. **Push image**
```bash
docker push imagename
```

3.22. **Inspect container**
```bash
docker inspect containername
```

3.23. **Pause container**
```bash
docker pause containername
```

3.24. **Unpause container**
```bash
docker unpause containername
```

3.25. **List volumes**
```bash
docker volume ls
```

3.26. **Remove volume**
```bash
docker volume rm volumename
```

3.27. **List networks**
```bash
docker network ls
```

3.28. **Prune containers**
```bash
docker container prune
```

3.29. **Prune images**
```bash
docker image prune -a
```

3.30. **Prune everything**
```bash
docker system prune -a
```

3.31. **Docker Compose up**
```bash
docker compose up -d
```

3.32. **Docker Compose down**
```bash
docker compose down
```

3.33. **Docker Compose build**
```bash
docker compose build
```

3.34. **Docker Compose logs**
```bash
docker compose logs -f
```

---

## 4. Network

4.1. **Check IP**
```bash
ip a
```

4.2. **Ping host**
```bash
ping -c 4 hostname
```

4.3. **Scan ports**
```bash
nmap -sV localhost
```

4.4. **Check open ports**
```bash
ss -tuln
```

4.5. **Check gateway**
```bash
ip route
```

4.6. **Check DNS**
```bash
cat /etc/resolv.conf
```

4.7. **DNS lookup**
```bash
dig domain.com
```

4.8. **Reverse DNS**
```bash
dig -x IP
```

4.9. **Check connections**
```bash
netstat -tuln
```

4.10. **Check ARP table**
```bash
arp -a
```

4.11. **Trace route**
```bash
traceroute hostname
```

4.12. **Trace with ICMP**
```bash
traceroute -I hostname
```

4.13. **Packet capture**
```bash
sudo tcpdump -i eth0
```

4.14. **Capture specific port**
```bash
sudo tcpdump -i eth0 port 80
```

4.15. **Check bandwidth**
```bash
sudo iftop -i eth0
```

4.16. **Show network stats**
```bash
netstat -s
```

4.17. **Check interface stats**
```bash
ip -s link
```

4.18. **Set IP**
```bash
sudo ip addr add 192.168.1.10/24 dev eth0
```

4.19. **Bring interface up**
```bash
sudo ip link set eth0 up
```

4.20. **Bring interface down**
```bash
sudo ip link set eth0 down
```

4.21. **Show MAC address**
```bash
ip link show eth0
```

4.22. **Check public IP**
```bash
curl ifconfig.me
```

4.23. **Resolve hostname**
```bash
host hostname
```

4.24. **Wireless scan**
```bash
sudo iwlist wlan0 scan
```

4.25. **Block IP**
```bash
sudo iptables -A INPUT -s IP -j DROP
```

4.26. **Allow port**
```bash
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
```

4.27. **List iptables**
```bash
sudo iptables -L -n
```

---

## 5. Files

5.1. **Find file**
```bash
find / -name filename
```

5.2. **Find large files**
```bash
find / -type f -size +100M
```

5.3. **Check file size**
```bash
du -sh filename
```

5.4. **Compress folder (tar.gz)**
```bash
tar -czvf name.tar.gz folder/
```

5.5. **Extract tar**
```bash
tar -xzvf name.tar.gz
```

5.6. **Extract to folder**
```bash
tar -xzvf name.tar.gz -C folder/
```

5.7. **Rsync sync**
```bash
rsync -avz source/ destination/
```

5.8. **Rsync with progress**
```bash
rsync -avzP source dest
```

5.9. **Copy file**
```bash
cp source dest
```

5.10. **Move file**
```bash
mv source dest
```

5.11. **Delete file**
```bash
rm filename
```

5.12. **Delete directory**
```bash
rm -rf dirname
```

5.13. **Create directory**
```bash
mkdir dirname
```

5.14. **List files**
```bash
ls -la
```

5.15. **List sorted by size**
```bash
ls -lS
```

5.16. **List sorted by date**
```bash
ls -lt
```

5.17. **Change ownership**
```bash
sudo chown user:group filename
```

5.18. **Change permissions**
```bash
chmod 755 filename
```

5.19. **Count lines in file**
```bash
wc -l filename
```

5.20. **View file contents**
```bash
cat filename
```

5.21. **View first lines**
```bash
head filename
```

5.22. **View last lines**
```bash
tail filename
```

5.23. **Follow file**
```bash
tail -f filename
```

5.24. **Search in file**
```bash
grep "text" filename
```

5.25. **Search recursively**
```bash
grep -r "text" /path
```

5.26. **Search with line numbers**
```bash
grep -n "text" filename
```

5.27. **Count occurrences**
```bash
grep -c "text" filename
```

5.28. **Compare files**
```bash
diff file1 file2
```

5.29. **Create link**
```bash
ln -s source linkname
```

5.30. **Check file type**
```bash
file filename
```

5.31. **Split file**
```bash
split -l 1000 filename part_
```

5.32. **Merge files**
```bash
cat part_* > filename
```

5.33. **Download file**
```bash
wget url -O filename
```

5.34. **Download with resume**
```bash
wget -c url
```

5.35. **Download with curl**
```bash
curl -O url
```

5.36. **MD5 checksum**
```bash
md5sum filename
```

5.37. **SHA256 checksum**
```bash
sha256sum filename
```

---

## 6. Processes

6.1. **List processes**
```bash
ps aux | grep name
```

6.2. **Top processes**
```bash
htop
```

6.3. **Process tree**
```bash
pstree
```

6.4. **List process by user**
```bash
ps -u username
```

6.5. **Kill process**
```bash
kill pid
```

6.6. **Kill by name**
```bash
pkill name
```

6.7. **Background process**
```bash
command &
```

6.8. **No hangup background**
```bash
nohup command &
```

6.9. **List jobs**
```bash
jobs
```

6.10. **Bring job to foreground**
```bash
fg %1
```

6.11. **Send job to background**
```bash
bg %1
```

6.12. **Kill job**
```bash
kill %1
```

6.13. **Nice process**
```bash
nice -n 10 command
```

6.14. **Change priority**
```bash
renice 10 -p pid
```

6.15. **Zombie processes**
```bash
ps aux | grep zombie
```

6.16. **Parent process ID**
```bash
ps -o ppid= -p pid
```

6.17. **Process runtime**
```bash
ps -eo pid,etime
```

6.18. **List open files**
```bash
lsof
```

6.19. **Files by process**
```bash
lsof -p pid
```

6.20. **Port by process**
```bash
lsof -i :port
```

---

## 7. Firewall (UFW)

7.1. **Enable**
```bash
sudo ufw enable
```

7.2. **Disable**
```bash
sudo ufw disable
```

7.3. **Status**
```bash
sudo ufw status
```

7.4. **Status verbose**
```bash
sudo ufw status verbose
```

7.5. **Allow port**
```bash
sudo ufw allow 22
```

7.6. **Deny port**
```bash
sudo ufw deny 80
```

7.7. **Allow service**
```bash
sudo ufw allow ssh
```

7.8. **Deny service**
```bash
sudo ufw deny http
```

7.9. **Allow IP**
```bash
sudo ufw allow from 192.168.1.10
```

7.10. **Allow subnet**
```bash
sudo ufw allow from 192.168.1.0/24
```

7.11. **Allow port from IP**
```bash
sudo ufw allow from 192.168.1.10 to any port 22
```

7.12. **Delete rule**
```bash
sudo ufw delete allow 80
```

7.13. **Reset firewall**
```bash
sudo ufw reset
```

7.14. **Reload firewall**
```bash
sudo ufw reload
```

7.15. **Default deny incoming**
```bash
sudo ufw default deny incoming
```

7.16. **Default allow outgoing**
```bash
sudo ufw default allow outgoing
```

---

## 8. Git

8.1. **Init repo**
```bash
git init
```

8.2. **Clone repo**
```bash
git clone url
```

8.3. **Clone branch**
```bash
git clone -b branchname url
```

8.4. **Check status**
```bash
git status
```

8.5. **Add file**
```bash
git add filename
```

8.6. **Add all**
```bash
git add .
```

8.7. **Commit**
```bash
git commit -m "message"
```

8.8. **Push**
```bash
git push origin branchname
```

8.9. **Pull**
```bash
git pull
```

8.10. **Fetch**
```bash
git fetch
```

8.11. **Merge**
```bash
git merge branchname
```

8.12. **Branches**
```bash
git branch
```

8.13. **New branch**
```bash
git checkout -b branchname
```

8.14. **Switch branch**
```bash
git checkout branchname
```

8.15. **Delete branch**
```bash
git branch -d branchname
```

8.16. **Force delete branch**
```bash
git branch -D branchname
```

8.17. **Log**
```bash
git log
```

8.18. **Short log**
```bash
git log --oneline
```

8.19. **Diff**
```bash
git diff
```

8.20. **Stash**
```bash
git stash
```

8.21. **Pop stash**
```bash
git stash pop
```

8.22. **List stash**
```bash
git stash list
```

8.23. **Tag**
```bash
git tag v1.0.0
```

8.24. **Push tags**
```bash
git push --tags
```

8.25. **Remote**
```bash
git remote -v
```

8.26. **Add remote**
```bash
git remote add origin url
```

8.27. **Set upstream**
```bash
git branch -u origin/branchname
```

8.28. **Reset to commit**
```bash
git reset --hard HEAD~1
```

8.29. **Clean untracked**
```bash
git clean -fd
```

8.30. **Ignore permissions**
```bash
git config core.fileMode false
```

---

## 9. Tar / Zip

9.1. **Create tar.gz**
```bash
tar -czvf name.tar.gz folder/
```

9.2. **Create tar.bz2**
```bash
tar -cjvf name.tar.bz2 folder/
```

9.3. **Extract tar.gz**
```bash
tar -xzvf name.tar.gz
```

9.4. **Extract tar.bz2**
```bash
tar -xjvf name.tar.bz2
```

9.5. **List tar contents**
```bash
tar -tzf name.tar.gz
```

9.6. **Extract to folder**
```bash
tar -xzvf name.tar.gz -C folder/
```

9.7. **Create zip**
```bash
zip -r name.zip folder/
```

9.8. **Extract zip**
```bash
unzip name.zip
```

9.9. **Extract zip to folder**
```bash
unzip name.zip -d folder/
```

9.10. **List zip contents**
```bash
unzip -l name.zip
```

---

## 10. Text Editing

10.1. **Nano save and exit**
```
Ctrl+O, Enter, Ctrl+X
```

10.2. **Nano search**
```
Ctrl+W
```

10.3. **Vim save and exit**
```bash
:wq
```

10.4. **Vim exit without saving**
```bash
:q!
```

10.5. **Vim insert mode**
```
i
```

10.6. **Vim command mode**
```
Esc
```

10.7. **Vim save**
```bash
:w
```

10.8. **Vim search**
```bash
/text
```

10.9. **Vim find next**
```
n
```

10.10. **Sed replace**
```bash
sed -i 's/old/new/g' file
```

10.11. **Sed delete line**
```bash
sed -i '/pattern/d' file
```

10.12. **Awk print column**
```bash
awk '{print $1}' file
```

10.13. **Awk find**
```bash
awk '/pattern/' file
```

10.14. **Cut column**
```bash
cut -d',' -f1 file
```

10.15. **Sort lines**
```bash
sort file
```

10.16. **Unique lines**
```bash
uniq file
```

10.17. **Count lines**
```bash
wc -l file
```

10.18. **Echo with newline**
```bash
echo -e "line1\nline2"
```

10.19. **Read file into var**
```bash
var=$(cat file)
```

10.20. **Here document**
```bash
cat <<EOF > file
content
EOF
```
