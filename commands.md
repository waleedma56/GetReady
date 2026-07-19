# Quick Commands

## Users

1. **Create user**
   ```bash
   sudo adduser username
   ```

2. **Add to sudo group**
   ```bash
   sudo usermod -aG sudo username
   ```

3. **Create with SSH key**
   ```bash
   sudo useradd -m -s /bin/bash username
   sudo mkdir /home/username/.ssh
   sudo cp key.pub /home/username/.ssh/authorized_keys
   sudo chmod 600 /home/username/.ssh/authorized_keys
   sudo chown -R username:username /home/username/.ssh
   ```

4. **Disable root login**
   ```bash
   sudo sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
   sudo systemctl restart sshd
   ```

---

## System

1. **Update packages**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install package**
   ```bash
   sudo apt install packagename
   ```

3. **Check disk space**
   ```bash
   df -h
   ```

4. **Check memory**
   ```bash
   free -h
   ```

5. **System info**
   ```bash
   neofetch
   ```

---

## Docker

1. **Add user to docker group**
   ```bash
   sudo usermod -aG docker username
   ```

2. **Start Docker**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

3. **List containers**
   ```bash
   docker ps -a
   ```

4. **Remove image**
   ```bash
   docker rmi imagename
   ```

---

## Network

1. **Check IP**
   ```bash
   ip a
   ```

2. **Ping host**
   ```bash
   ping -c 4 hostname
   ```

3. **Scan ports**
   ```bash
   nmap -sV localhost
   ```

4. **Check open ports**
   ```bash
   ss -tuln
   ```

---

## Files

1. **Find file**
   ```bash
   find / -name filename
   ```

2. **Check file size**
   ```bash
   du -sh filename
   ```

3. **Compress folder**
   ```bash
   tar -czvf name.tar.gz folder/
   ```

4. **Extract tar**
   ```bash
   tar -xzvf name.tar.gz
   ```

5. **Rsync sync**
   ```bash
   rsync -avz source/ destination/
   ```

---

## Processes

1. **List processes**
   ```bash
   ps aux | grep name
   ```

2. **Kill process**
   ```bash
   kill pid
   ```

3. **Kill by name**
   ```bash
   pkill name
   ```

4. **Check resource usage**
   ```bash
   htop
   ```

---

## Firewall (UFW)

1. **Enable**
   ```bash
   sudo ufw enable
   ```

2. **Allow port**
   ```bash
   sudo ufw allow 22
   ```

3. **Deny port**
   ```bash
   sudo ufw deny 80
   ```

4. **Status**
   ```bash
   sudo ufw status
   ```
