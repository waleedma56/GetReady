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

5. **Delete user**
   ```bash
   sudo userdel username
   ```

6. **Lock user**
   ```bash
   sudo usermod -L username
   ```

7. **Change user password**
   ```bash
   sudo passwd username
   ```

8. **List all users**
   ```bash
   cat /etc/passwd
   ```

9. **Check user groups**
   ```bash
   groups username
   ```

10. **Switch user**
    ```bash
    su - username
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

3. **Remove package**
   ```bash
   sudo apt remove packagename
   ```

4. **Check disk space**
   ```bash
   df -h
   ```

5. **Check memory**
   ```bash
   free -h
   ```

6. **System info**
   ```bash
   neofetch
   ```

7. **Uptime**
   ```bash
   uptime
   ```

8. **Check OS version**
   ```bash
   cat /etc/os-release
   ```

9. **Check kernel**
   ```bash
   uname -r
   ```

10. **List CPU info**
    ```bash
    lscpu
    ```

11. **List hardware**
    ```bash
    lshw
    ```

12. **Check load average**
    ```bash
    cat /proc/loadavg
    ```

13. **Check mounts**
    ```bash
    mount | column -t
    ```

14. **Edit cron jobs**
    ```bash
    sudo crontab -e
    ```

15. **List cron jobs**
    ```bash
    sudo crontab -l
    ```

16. **Enable service**
    ```bash
    sudo systemctl enable servicename
    ```

17. **Disable service**
    ```bash
    sudo systemctl disable servicename
    ```

18. **Check service status**
    ```bash
    sudo systemctl status servicename
    ```

19. **List running services**
    ```bash
    sudo systemctl list-units --type=service --state=running
    ```

20. **Check last reboot**
    ```bash
    last reboot
    ```

21. **Check failed services**
    ```bash
    sudo systemctl --failed
    ```

22. **View system log**
    ```bash
    sudo journalctl -xe
    ```

23. **View recent logs**
    ```bash
    sudo tail -f /var/log/syslog
    ```

24. **Check hostname**
    ```bash
    hostname
    ```

25. **Set hostname**
    ```bash
    sudo hostnamectl set-hostname newname
    ```

26. **Reboot**
    ```bash
    sudo reboot
    ```

27. **Shutdown**
    ```bash
    sudo shutdown -h now
    ```

28. **Schedule shutdown**
    ```bash
    sudo shutdown -h +60
    ```

29. **Cancel shutdown**
    ```bash
    sudo shutdown -c
    ```

30. **Clear memory cache**
    ```bash
    sudo sync && echo 3 | sudo tee /proc/sys/vm/drop_caches
    ```

---

## Docker

1. **Install Docker**
   ```bash
   curl -fsSL https://get.docker.com | sudo bash
   ```

2. **Add user to docker group**
   ```bash
   sudo usermod -aG docker username
   ```

3. **Start Docker**
   ```bash
   sudo systemctl start docker
   sudo systemctl enable docker
   ```

4. **List containers**
   ```bash
   docker ps -a
   ```

5. **List running containers**
   ```bash
   docker ps
   ```

6. **Remove image**
   ```bash
   docker rmi imagename
   ```

7. **Remove container**
   ```bash
   docker rm containername
   ```

8. **Stop container**
   ```bash
   docker stop containername
   ```

9. **Start container**
   ```bash
   docker start containername
   ```

10. **Restart container**
    ```bash
    docker restart containername
    ```

11. **View container logs**
    ```bash
    docker logs containername
    ```

12. **Follow container logs**
    ```bash
    docker logs -f containername
    ```

13. **Execute command in container**
    ```bash
    docker exec -it containername bash
    ```

14. **Build image**
    ```bash
    docker build -t imagename .
    ```

15. **Pull image**
    ```bash
    docker pull imagename
    ```

16. **Push image**
    ```bash
    docker push imagename
    ```

17. **List images**
    ```bash
    docker images
    ```

18. **Run container**
    ```bash
    docker run -it imagename bash
    ```

19. **Run container in background**
    ```bash
    docker run -d imagename
    ```

20. **Map port**
    ```bash
    docker run -d -p 8080:80 imagename
    ```

21. **List volumes**
    ```bash
    docker volume ls
    ```

22. **Remove volume**
    ```bash
    docker volume rm volumename
    ```

23. **List networks**
    ```bash
    docker network ls
    ```

24. **Inspect container**
    ```bash
    docker inspect containername
    ```

25. **Pause container**
    ```bash
    docker pause containername
    ```

26. **Unpause container**
    ```bash
    docker unpause containername
    ```

27. **Kill container**
    ```bash
    docker kill containername
    ```

28. **Prune unused containers**
    ```bash
    docker container prune
    ```

29. **Prune unused images**
    ```bash
    docker image prune -a
    ```

30. **Prune everything**
    ```bash
    docker system prune -a
    ```

31. **Docker Compose up**
    ```bash
    docker compose up -d
    ```

32. **Docker Compose down**
    ```bash
    docker compose down
    ```

33. **Docker Compose build**
    ```bash
    docker compose build
    ```

34. **Docker Compose logs**
    ```bash
    docker compose logs -f
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

5. **Check gateway**
   ```bash
   ip route
   ```

6. **Check DNS**
   ```bash
   cat /etc/resolv.conf
   ```

7. **DNS lookup**
   ```bash
   dig domain.com
   ```

8. **Reverse DNS**
   ```bash
   dig -x IP
   ```

9. **Check connections**
   ```bash
   netstat -tuln
   ```

10. **Check all connections**
    ```bash
    ss -tuln
    ```

11. **Checkarp table**
    ```bash
    arp -a
    ```

12. **Trace route**
    ```bash
    traceroute hostname
    ```

13. **Trace with ICMP**
    ```bash
    traceroute -I hostname
    ```

14. **Packet capture**
    ```bash
    sudo tcpdump -i eth0
    ```

15. **Capture specific port**
    ```bash
    sudo tcpdump -i eth0 port 80
    ```

16. **Check bandwidth**
    ```bash
    iftop -i eth0
    ```

17. **Show network stats**
    ```bash
    netstat -s
    ```

18. **Check interface stats**
    ```bash
    ip -s link
    ```

19. **Set IP**
    ```bash
    sudo ip addr add 192.168.1.10/24 dev eth0
    ```

20. **Bring interface up**
    ```bash
    sudo ip link set eth0 up
    ```

21. **Bring interface down**
    ```bash
    sudo ip link set eth0 down
    ```

22. **Show MAC address**
    ```bash
    ip link show eth0
    ```

23. **Check public IP**
    ```bash
    curl ifconfig.me
    ```

24. **Resolve hostname**
    ```bash
    host hostname
    ```

25. **Wireless scan**
    ```bash
    sudo iwlist wlan0 scan
    ```

26. **Block IP**
    ```bash
    sudo iptables -A INPUT -s IP -j DROP
    ```

27. **Allow port**
    ```bash
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    ```

28. **List iptables**
    ```bash
    sudo iptables -L -n
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

6. **Copy file**
   ```bash
   cp source dest
   ```

7. **Move file**
   ```bash
   mv source dest
   ```

8. **Delete file**
   ```bash
   rm filename
   ```

9. **Delete directory**
   ```bash
   rm -rf dirname
   ```

10. **Create directory**
    ```bash
    mkdir dirname
    ```

11. **List files**
    ```bash
    ls -la
    ```

12. **List sorted by size**
    ```bash
    ls -lS
    ```

13. **List sorted by date**
    ```bash
    ls -lt
    ```

14. **Change ownership**
    ```bash
    sudo chown user:group filename
    ```

15. **Change permissions**
    ```bash
    chmod 755 filename
    ```

16. **Copy with progress**
    ```bash
    rsync -avzP source dest
    ```

17. **Find large files**
    ```bash
    find / -type f -size +100M
    ```

18. **Count lines in file**
    ```bash
    wc -l filename
    ```

19. **View file contents**
    ```bash
    cat filename
    ```

20. **View first lines**
    ```bash
    head filename
    ```

21. **View last lines**
    ```bash
    tail filename
    ```

22. **Follow file**
    ```bash
    tail -f filename
    ```

23. **Search in file**
    ```bash
    grep "text" filename
    ```

24. **Search recursively**
    ```bash
    grep -r "text" /path
    ```

25. **Count occurrences**
    ```bash
    grep -c "text" filename
    ```

26. **Show line numbers**
    ```bash
    grep -n "text" filename
    ```

27. **Compare files**
    ```bash
    diff file1 file2
    ```

28. **Create link**
    ```bash
    ln -s source linkname
    ```

29. **List links**
    ```bash
    ls -la | grep ^l
    ```

30. **Check file type**
    ```bash
    file filename
    ```

31. **Split file**
    ```bash
    split -l 1000 filename part_
    ```

32. **Merge files**
    ```bash
    cat part_* > filename
    ```

33. **Download file**
    ```bash
    wget url -O filename
    ```

34. **Download with resume**
    ```bash
    wget -c url
    ```

35. **Download with curl**
    ```bash
    curl -O url
    ```

36. **MD5 checksum**
    ```bash
    md5sum filename
    ```

37. **SHA256 checksum**
    ```bash
    sha256sum filename
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

5. **Top processes**
   ```bash
   top
   ```

6. **Process tree**
   ```bash
   pstree
   ```

7. **List process by user**
   ```bash
   ps -u username
   ```

8. **Background process**
   ```bash
   command &
   ```

9. **No hangup background**
   ```bash
   nohup command &
   ```

10. **List jobs**
    ```bash
    jobs
    ```

11. **Bring job to foreground**
    ```bash
    fg %1
    ```

12. **Send job to background**
    ```bash
    bg %1
    ```

13. **Kill job**
    ```bash
    kill %1
    ```

14. **Nice process**
    ```bash
    nice -n 10 command
    ```

15. **Change priority**
    ```bash
    renice 10 -p pid
    ```

16. **Zombie processes**
    ```bash
    ps aux | grep zombie
    ```

17. **Parent process**
    ```bash
    ps -o ppid= -p pid
    ```

18. **Process runtime**
    ```bash
    ps -eo pid,etime
    ```

19. **Check pid max**
    ```bash
    cat /proc/sys/kernel/pid_max
    ```

20. **List open files**
    ```bash
    lsof
    ```

21. **Files by process**
    ```bash
    lsof -p pid
    ```

22. **Port by process**
    ```bash
    lsof -i :port
    ```

---

## Firewall (UFW)

1. **Enable**
   ```bash
   sudo ufw enable
   ```

2. **Disable**
   ```bash
   sudo ufw disable
   ```

3. **Allow port**
   ```bash
   sudo ufw allow 22
   ```

4. **Deny port**
   ```bash
   sudo ufw deny 80
   ```

5. **Status**
   ```bash
   sudo ufw status
   ```

6. **Status verbose**
   ```bash
   sudo ufw status verbose
   ```

7. **Allow service**
   ```bash
   sudo ufw allow ssh
   ```

8. **Deny service**
   ```bash
   sudo ufw deny http
   ```

9. **Allow IP**
   ```bash
   sudo ufw allow from 192.168.1.10
   ```

10. **Allow subnet**
    ```bash
    sudo ufw allow from 192.168.1.0/24
    ```

11. **Allow port from IP**
    ```bash
    sudo ufw allow from 192.168.1.10 to any port 22
    ```

12. **Delete rule**
    ```bash
    sudo ufw delete allow 80
    ```

13. **Reset firewall**
    ```bash
    sudo ufw reset
    ```

14. **Reload firewall**
    ```bash
    sudo ufw reload
    ```

15. **Default deny incoming**
    ```bash
    sudo ufw default deny incoming
    ```

16. **Default allow outgoing**
    ```bash
    sudo ufw default allow outgoing
    ```

---

## Git

1. **Init repo**
   ```bash
   git init
   ```

2. **Clone repo**
   ```bash
   git clone url
   ```

3. **Clone branch**
   ```bash
   git clone -b branchname url
   ```

4. **Check status**
   ```bash
   git status
   ```

5. **Add file**
   ```bash
   git add filename
   ```

6. **Add all**
   ```bash
   git add .
   ```

7. **Commit**
   ```bash
   git commit -m "message"
   ```

8. **Push**
   ```bash
   git push origin branchname
   ```

9. **Pull**
   ```bash
   git pull
   ```

10. **Fetch**
    ```bash
    git fetch
    ```

11. **Merge**
    ```bash
    git merge branchname
    ```

12. **Branches**
    ```bash
    git branch
    ```

13. **New branch**
    ```bash
    git checkout -b branchname
    ```

14. **Switch branch**
    ```bash
    git checkout branchname
    ```

15. **Delete branch**
    ```bash
    git branch -d branchname
    ```

16. **Force delete branch**
    ```bash
    git branch -D branchname
    ```

17. **Log**
    ```bash
    git log
    ```

18. **Short log**
    ```bash
    git log --oneline
    ```

19. **Diff**
    ```bash
    git diff
    ```

20. **Stash**
    ```bash
    git stash
    ```

21. **Pop stash**
    ```bash
    git stash pop
    ```

22. **List stash**
    ```bash
    git stash list
    ```

23. **Tag**
    ```bash
    git tag v1.0.0
    ```

24. **Push tags**
    ```bash
    git push --tags
    ```

25. **Remote**
    ```bash
    git remote -v
    ```

26. **Add remote**
    ```bash
    git remote add origin url
    ```

27. **Set upstream**
    ```bash
    git branch -u origin/branchname
    ```

28. **Reset to commit**
    ```bash
    git reset --hard HEAD~1
    ```

29. **Clean untracked**
    ```bash
    git clean -fd
    ```

30. **Ignore permissions**
    ```bash
    git config core.fileMode false
    ```

---

## Tar / Zip

1. **Create tar.gz**
   ```bash
   tar -czvf name.tar.gz folder/
   ```

2. **Create tar.bz2**
   ```bash
   tar -cjvf name.tar.bz2 folder/
   ```

3. **Extract tar.gz**
   ```bash
   tar -xzvf name.tar.gz
   ```

4. **Extract tar.bz2**
   ```bash
   tar -xjvf name.tar.bz2
   ```

5. **List tar contents**
   ```bash
   tar -tzf name.tar.gz
   ```

6. **Extract to folder**
   ```bash
   tar -xzvf name.tar.gz -C folder/
   ```

7. **Create zip**
   ```bash
   zip -r name.zip folder/
   ```

8. **Extract zip**
   ```bash
   unzip name.zip
   ```

9. **Extract to folder**
   ```bash
   unzip name.zip -d folder/
   ```

10. **List zip contents**
    ```bash
    unzip -l name.zip
    ```

---

## Text Editing

1. **Nano save and exit**
   ```bash
   Ctrl+O, Enter, Ctrl+X
   ```

2. **Nano search**
   ```bash
   Ctrl+W
   ```

3. **Vim save and exit**
   ```bash
   :wq
   ```

4. **Vim exit without saving**
   ```bash
   :q!
   ```

5. **Vim insert mode**
   ```bash
   i
   ```

6. **Vim command mode**
   ```bash
   Esc
   ```

7. **Vim save**
   ```bash
   :w
   ```

8. **Vim search**
   ```bash
   /text
   ```

9. **Vim find next**
   ```bash
   n
   ```

10. **Sed replace**
    ```bash
    sed -i 's/old/new/g' file
    ```

11. **Sed delete line**
    ```bash
    sed -i '/pattern/d' file
    ```

12. **Awk print column**
    ```bash
    awk '{print $1}' file
    ```

13. **Awk find**
    ```bash
    awk '/pattern/' file
    ```

14. **Cut column**
    ```bash
    cut -d',' -f1 file
    ```

15. **Sort lines**
    ```bash
    sort file
    ```

16. **Unique lines**
    ```bash
    uniq file
    ```

17. **Count lines**
    ```bash
    wc -l file
    ```

18. **Echo with newline**
    ```bash
    echo -e "line1\nline2"
    ```

19. **Read file into var**
    ```bash
    var=$(cat file)
    ```

20. **Here document**
    ```bash
    cat <<EOF > file
    content
    EOF
    ```
