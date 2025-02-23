FROM ubuntu:latest

# Install dependencies
RUN apt update && apt install -y curl git zsh build-essential sudo

RUN useradd -m brewuser && echo "brewuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the new user and install Homebrew
USER brewuser
WORKDIR /home/brewuser

RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

RUN echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc

RUN /bin/bash -c "eval \"$($(brew --prefix)/bin/brew shellenv)\" && brew install gcc"

USER root
WORKDIR /

# Copy setup script
COPY setup.sh /setup.sh
RUN chmod +x /setup.sh

# Set entrypoint
ENTRYPOINT ["./setup.sh"]
