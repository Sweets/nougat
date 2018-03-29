FROM debian:stretch

RUN export DEBIAN_FRONTEND=noninteractive; \
    apt-get update -qq && \
    apt-get install -qq -y \
      xvfb \
      xorg \
      x11vnc \
      openbox \
      dbus-x11 \
      xnee \
      slop \
      maim \
      scrot \
      imagemagick \
      bats \
      xclip \
      file \
      xfonts-100dpi \
      xfonts-75dpi \
      xfonts-cyrillic \
      fonts-liberation && \
    cd /tmp && \
    useradd testuser && \
    usermod -a -G input testuser && \
    mkdir -p /home/testuser && \
    chown -R testuser:testuser /home/testuser/ && \
    mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    chown root /tmp/.X11-unix/

USER testuser

CMD echo "A VNC server will be started at $(ip addr show eth0 | grep inet | awk '{print $2}' | sed 's/\/.*//g'):5900"; \
    echo "You can point any VNC client at that address to troubleshoot any tests that hang"; \
    xvfb-run --server-args "-screen 0 1920x1080x24" xterm -e "bash -c 'set -x;env;x11vnc -bg -forever &> /dev/null & disown; openbox &> /dev/null & disown;set -e;cd /opt/nougat/tests;mkdir -p ~/Screenshots;./runner.sh' 2>&1| tee -a /tmp/test.log" & tail -F /tmp/test.log --pid=$!; cp /tmp/test.log /opt/nougat; cp -R /home/testuser/Screenshots /opt/nougat; grep -q -E '^not ok' /tmp/test.log && exit 1 || exit 0;
