# Quick Commands

## Users

### Create user
```bash
sudo adduser username
```

### Add to sudo group
```bash
sudo usermod -aG sudo username
```

### Create with SSH key
```bash
sudo useradd -m -s /bin/bash username
sudo mkdir /home/username/.ssh
sudo cp key.pub /home/username/.ssh/authorized_keys
sudo chmod 600 /home/username/.ssh/authorized_keys
sudo chown -R username:username /home/username/.ssh
```

### Disable root login
```bash
sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sudo systemctl restart sshd
```

---

## System

### Update packages
```bash
sudo apt update && sudo apt upgrade -y
```

### Install package
```bash
sudo apt install packagename
```

### Check disk space
```bash
df -h
```

### Check memory
```bash
free -h
```

### System info
```bash
neofetch
```

---

## Docker

### Add user to docker group
```bash
sudo usermod -aG docker username
```

### Start Docker
```bash
sudo systemctl start docker
sudo systemctl enable docker
```

### List containers
```bash
docker ps -a
```

### Remove image
```bash
docker rmi imagename
```

---

## Network

### Check IP
```bash
ip a
```

### Ping host
```bash
ping -c 4 hostname
```

### Scan ports
```bash
nmap -sV localhost
```

### Check open ports
```bash
ss -tuln
```

---

## Files

### Find file
```bash
find / -name filename
```

### Check file size
```bash
du -sh filename
```

### Compress folder
```bash
tar -czvf name.tar.gz folder/
```

### Extract tar
```bash
tar -xzvf name.tar.gz
```

### Rsync sync
```bash
rsync -avz source/ destination/
```

---

## Processes

### List processes
```bash
ps aux | grep name
```

### Kill process
```bash
kill pid
```

### Kill by name
```bash
pkill name
```

### Check resource usage
```bash
htop
```

---

## Firewall (UFW)

### Enable
```bash
sudo ufw enable
```

### Allow port
```bash
sudo ufw allow 22
```

### Deny port
```bash
sudo ufw deny 80
```

### Status
```bash
sudo ufw status
```
