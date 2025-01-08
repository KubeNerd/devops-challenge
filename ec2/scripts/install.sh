#!/bin/bash
# Install docker https://docs.aws.amazon.com/pt_br/serverless-application-model/latest/developerguide/install-docker.html

set -e

# Função para exibir mensagens de erro e sair
erro() {
    echo "Erro: $1"
    exit 1
}

# Atualizando pacotes e dependências
echo "Atualizando pacotes e dependências..."
sudo apt-get update -y || erro "Falha ao atualizar pacotes"
sudo apt-get upgrade -y || erro "Falha ao atualizar pacotes"

# Instalando pacotes necessários
echo "Instalando pacotes necessários..."
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common || erro "Falha na instalação de pacotes necessários"

# Adicionando chave GPG do Docker
echo "Adicionando chave GPG do Docker..."
if [ ! -f /usr/share/keyrings/docker-archive-keyring.gpg ]; then
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg || erro "Falha ao adicionar chave GPG"
else
    echo "Chave GPG já existente."
fi

# Adicionando repositório do Docker
echo "Adicionando repositório do Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualizando novamente após adicionar repositório
echo "Atualizando lista de pacotes após adicionar repositório do Docker..."
sudo apt-get update -y || erro "Falha ao atualizar pacotes após adicionar repositório"

# Instalando Docker
echo "Instalando Docker..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io || erro "Falha na instalação do Docker"

# Iniciando e habilitando serviço Docker
echo "Iniciando e habilitando serviço Docker..."
sudo systemctl start docker || erro "Falha ao iniciar o Docker"
sudo systemctl enable docker || erro "Falha ao habilitar o Docker"

# Adicionando usuário ao grupo Docker
echo "Adicionando usuário ao grupo Docker..."
sudo usermod -aG docker $USER || erro "Falha ao adicionar usuário ao grupo Docker"
sudo chown $USER:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock


# Baixando e iniciando contêiner Apache
echo "Baixando e iniciando contêiner Apache..."
sudo docker run -d --name apache-server -p 80:80 httpd:latest || erro "Falha ao iniciar contêiner Apache"

echo "Instalação concluída. Acesse o IP público da instância para visualizar a página padrão do Apache."