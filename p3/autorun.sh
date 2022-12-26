#!/bin/sh

checkDockerInstall() {
	# docker rm -f $(docker ps -a -q) >/dev/null 2>&1
	echo "🔎  Verifying Docker installation ..."
	if [ -x "$(command -v docker)" ]
	then
		VER=$(docker version -f '{{.Server.Platform.Name}}' | awk '{print $1 " " $2 " " $3}')
		echo "🐳  $VER is installed and ready to use"
	else
		echo "❌   Docker installation wasn't proprely installed"
		exit
	fi
}

setupDockerRepository() {
	if ! [ -x "$(sudo apt-get install \
		ca-certificates \
		curl \
		gnupg \
		lsb-release 2> /dev/null )" ]
	then
		echo "❌   Error during dependencies installation"
		exit
	fi
		
	sudo mkdir -p /etc/apt/keyrings

	if ! [ -x "$(curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg 2> /dev/null)" ]
	then
		echo "❌   Error during Official GPG key adding"
		exit
	fi

	echo \
  	"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  	$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	echo "🍻   Docker Repository set"
	installDockerEngineUbuntu	
}

installDockerLinux() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		setupDockerRepository
	fi
}

downloadDockerDesktop() {
	if [[ $(uname -m) == 'arm64' ]]; then
		echo "⬇️   Downloading for Mac with Apple Silicon"
		if  [ -x "$(curl https://desktop.docker.com/mac/main/arm64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-arm64)" ]
		then
			echo "❌   Error during download"
			exit
		fi
	else
		echo "⬇️   Downloading for Mac with Intel chip"
		if  [ -x "$(curl --output /tmp/Docker.dmg -sS https://desktop.docker.com/mac/main/amd64/Docker.dmg?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-mac-amd64)" ]
		then
			echo "❌   Error during download"
			exit
		fi
	fi
}

installDockerDesktop() {
	echo "🛠   Docker installation in progress ..."
	sudo hdiutil attach -quiet /tmp/Docker.dmg
	echo "😉  It should not be long now ..."
	sudo /Volumes/Docker/Docker.app/Contents/MacOS/install --accept-license >/dev/null 2>&1
	sudo hdiutil detach -quiet /Volumes/Docker 
	open -a Docker && echo "⏳  Wait for Docker Desktop starting" && sleep 35
}

installDockerMac() {
	if [[ "$OSTYPE" == "darwin"* ]]; then
		downloadDockerDesktop
		installDockerDesktop
		checkDockerInstall
	fi
}

isDockerInstalled() {
	if [ -x "$(command -v docker)" ]
	then
		echo "🐳   $VER is already installed"
	else
		echo "❗️  Docker is not installed"
		echo "🏗   Let's proceed to its installation ..."
		installDockerLinux
		installDockerMac
	fi
}

installK3d() {
	echo "🏗   k3d will be installed soon ..."
	if [ -x "$(curl -sS https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash)" ]
	then
		echo "❌  Error during K3D downloading"
	else
		K3D=$(k3d --version | awk 'NR==1 {print $1 " " $3}')
		echo "🐳  $K3D is now installed and ready to use"
	fi

}

isK3dInstalled() {
	if [ -x "$(which k3d)" ]
	then
		K3D=$(k3d --version | awk 'NR==1 {print $1 " " $3}')
		echo "🐳  $K3D is already installed"
	else
		echo "❗️  k3d is not installed"
		installK3d
	fi
}

whatOS() {
	if [[ "$OSTYPE" == "linux-gnu"* ]]; then
		OSLINUX=$(lsb_release -ds)
		echo "💻  Install bundle for $OSLINUX"
		sudo apt-get update 2> /dev/null
		if ! [ isDockerInstalled ];
		then
			setupDockerRepository
			sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin 2> /dev/null
		fi
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		OS=$(sw_vers -productName)
		OSVER=$(sw_vers -productVersion)
		echo "💻  Install bundle for $OS $OSVER"
		isDockerInstalled
		isK3dInstalled
	else
		"❌   This script only supports Ubuntu and MacOS, sorry bud 🙏🏽"
		exit
	fi
}

whatOS
