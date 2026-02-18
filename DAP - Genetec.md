# **Instalação do SDK Genetec**

A instalação do SDK:

* Cria variáveis de ambiente:  
  * `GSC_SDK` → .NET Framework  
  * `GSC_SDK_CORE` → .NET 8  
* Escreve o caminho de instalação no **Windows Registry**  
* Copia as DLLs do SDK para os diretórios corretos

## **Passos para a instalação Ativação**

1. Entrar no DAP  
2. Baixar **Security Center \+ SDK** pelo **Portal**  
3. Instalar o Security Center  
4. Ativar a licença de desenvolvimento  
5. Instalar o Security Center SDK

## **Passos para a rodar SDK no Notebook Desenvolvimento**

O SDK depende de:

* Certificado `.cert`  
* Licença válida no Security Center  
* Assemblies resolvidas via instalação correta

❌Não existe pacote NUGET  
❌Não existe .msi  
❌Não existe SDK versionado no GitHub  
❌Não existe Setup automatizado  
❌Não existe Script de Instalação

❗Tudo isso é para ser distribuído via **DAP**

### 

### **Quando não utilizar o RegEdit**

Você **NÃO precisa mexer no Registry** se:

* ✅ O **Security Center SDK foi instalado corretamente**  
* ✅ As variáveis de ambiente existem:  
  * `GSC_SDK` (para .NET Framework)  
  * `GSC_SDK_CORE` (para .NET 8\)  
* ✅ Seu `.csproj` referência o SDK usando essas variáveis  
* ✅ `Copy Local = False` (`<Private>False</Private>`)

**99% dos erros** de `Genetec.Sdk.dll not found` são resolvidos apenas com:

* reinstalar o SDK **ou**  
* corrigir o `.csproj`

| Situação | Regedit? |
| ----- | ----- |
| SDK não instalado | ❌ Não |
| Variável GSC\_SDK não existe | ❌ Não (reinstala SDK) |
| HintPath errado no .csproj | ❌ Não |
| App externo simples (console/WPF) | ❌ Não |
| Plugin / Service legado / runtime estranho | ⚠️ Talvez |
| Tentando “forçar” DLL | ❌ Nunca |

**Depende do tipo de aplicação.**

* **Aplicação externa (console, WPF, service, web app)**  
  👉 Precisa do SDK instalado  
  👉 NÃO precisa do Security Center completo instalado  
* **Plugin / Workspace / Role interno do Security Center**  
  👉 Precisa do Security Center instalado  
  👉 NÃO precisa instalar o SDK separadamente

### 📌 **Cenário 1 — Aplicação externa (o mais comum)**

#### 

#### **✅ Requisitos**

| Item | Necessário |
| ----- | ----- |
| Security Center SDK | ✅ Sim |
| Security Center instalado | ❌ Não |
| Acesso de rede ao SC | ✅ Sim |
| Licença válida no SC | ✅ Sim |
| Certificado SDK | ✅ Sim |

👉 O **SDK já contém as DLLs necessárias** (`Genetec.Sdk.dll`, etc.).  
👉 O app **se conecta remotamente** ao Security Center via Directory.

### 

#### **Arquitetura típica Genetec/DAP**

\[ Seu App \]  
     |  
     |  (SDK)  
     |  
\[ Security Center Server \]

### 

### 

### **📌 Cenário 2 — Plugin / Workspace / Role interno**

#### ✅ Requisitos

| Item | Necessário |
| ----- | ----- |
| Security Center instalado | ✅ Sim |
| SDK instalado separadamente | ❌ Não |
| SDK redistribuído | ❌ Nunca |

👉 O plugin **roda dentro do processo do Security Center**  
👉 Ele usa **as DLLs que já vêm com o SC instalado**

#### **Arquitetura típica Genetec/DAP**

\[ Security Center \]  
     └── \[ Seu Plugin \]

✅ Aqui o SDK **já está “embutido” no ambiente do SC**.

## **✅ Regra de ouro (memorize)**

**Aplicação fora do Security Center → SDK instalado**  
**Código rodando dentro do Security Center → SC instalado**

Nunca os dois ao mesmo tempo **sem necessidade**.

### Em forma de decisão rápida

Meu app é um plugin/role do SC?  
 ├─ Sim → Precisa do Security Center  
 │       → NÃO instalar SDK separado  
 └─ Não → É app externo  
         → Precisa do SDK  
         → NÃO precisa do Security Center

## **O que é a variável GSC\_SDK**

`GSC_SDK` é uma **variável de ambiente** que aponta para a **pasta onde o Security Center SDK está instalado** (para **.NET Framework**).

Exemplo típico:

C:\\Program Files (x86)\\Genetec Security Center SDK

⚠️ Importante

* **.NET Framework** → `GSC_SDK`  
* **.NET 8** → `GSC_SDK_CORE`  
  Não misture.


### **1️⃣ Abrir Variáveis de Ambiente**

* Pressione **Win \+ R**

Digite:  
sysdm.cpl

*   
* Enter  
* Vá na aba **Avançado**  
* Clique em **Variáveis de Ambiente**

---

### **2️⃣ Criar a variável GSC\_SDK**

Você pode criar como **Variável do Sistema** (recomendado).

Em **Variáveis do sistema**:

* Clique em **Novo…**

**Nome da variável**:  
GSC\_SDK

* **Valor da variável** (exemplo):  
  C:\\Program Files (x86)\\Genetec Security Center SDK

✅ Confirme tudo com **OK**

### **3️⃣ Reiniciar Visual Studio (obrigatório)**

O Visual Studio **não lê variáveis novas em tempo real**.

➡️ **Feche e abra o Visual Studio novamente**

### **4️⃣ Validar se funcionou**

Abra **PowerShell** e execute:

PowerShell  
echo $env:GSC\_SDK  
Mostrar mais linhas

Se aparecer o caminho → ✅ correto

Teste se a DLL existe:

PowerShell  
Test-Path "$env:GSC\_SDK\\Genetec.Sdk.dll"  
Mostrar mais linhas

* `True` → ✅ SDK encontrado  
* `False` → ❌ caminho errado ou SDK não instalado

### ✅ Forma alternativa (PowerShell – rápido)

Execute **PowerShell como Administrador**:

PowerShell  
setx GSC\_SDK "C:\\Program Files (x86)\\Genetec Security Center SDK" /M

### 

### 

### 

### ✅ Como o projeto deve usar essa variável (.csproj)

Para **.NET Framework**:

XML  
\<ItemGroup\>  
\<Reference Include="Genetec.Sdk"\>  
\<HintPath\>$(GSC\_SDK)\\Genetec.Sdk.dll\</HintPath\>  
\<Private\>False\</Private\>  
\</Reference\>  
\</ItemGroup\>  
Mostrar mais linhas

⚠️ `Private=False` é **obrigatório**  
(Não copiar a DLL para `bin`)

### ❌ Erros comuns (evite)

❌ Criar `GSC_SDK` apontando para:

* `bin`  
* `lib`  
* pasta de projeto  
* pasta do Security Center (não SDK)

❌ Copiar `Genetec.Sdk.dll` manualmente  
❌ Usar `GSC_SDK` em projeto **.NET 8**  
❌ Alterar Registry manualmente para isso

### ✅ Se for .NET 8 (atenção\!)

Use **outra variável**:

GSC\_SDK\_CORE

Exemplo:

C:\\Program Files\\Genetec\\Security Center SDK Core

E no `.csproj`:

XML  
\<HintPath\>$(GSC\_SDK\_CORE)\\Genetec.Sdk.dll\</HintPath\>

| Situação | Ação |
| ----- | ----- |
| SDK não instalado | Instalar SDK (Portal Genetec) |
| `GSC_SDK` não existe | Criar variável |
| VS não reconhece | Reiniciar VS |
| DLL não encontrada | Verificar caminho |
| .NET 8 | Usar `GSC_SDK_CORE` |

# **Arquitetura recomendada (padrão ouro)**

## **✅ Separar em 3 camadas / 3 projetos**

Solution  
│  
├── Core (Class Library)  
│  
├── Worker (Windows Service)  
│  
└── API Interna (Web API)

## 🧠 Arquitetura completa (visual)

       ┌──────────────┐  
        │ Sistemas     │  
        │ Internos     │  
        └──────┬───────┘  
               │ HTTP  
        ┌──────▼───────┐  
        │ API Interna  │  
        │ ASP.NET      │  
        └──────┬───────┘  
               │  
        ┌──────▼───────┐  
        │ Core          │  
        │ (Genetec SDK) │  
        └──────┬───────┘  
               │  
        ┌──────▼───────┐  
        │ Worker        │  
        │ WindowsSvc    │  
        └──────┬───────┘  
               │  
        ┌──────▼───────┐  
        │ Genetec SC    │  
        └──────────────┘

## 

## **✅ Sim, a conexão usa TCP, mas você NÃO trabalha com socket TCP diretamente**

Quando você usa o **Genetec SDK**, a comunicação com o **Security Center**:

* ✅ **É baseada em TCP**  
* ✅ Usa **protocolo proprietário da Genetec**  
* ✅ É **totalmente encapsulada pelo SDK**  
* ❌ **Você nunca abre `Socket`, `TcpClient` ou porta manualmente**

## **🔌 Como a conexão realmente funciona**

### **O fluxo real é este:**

Seu App  
  └── Genetec.Sdk.Engine  
        └── TCP (proprietário)  
              └── Security Center Directory

## 🧠 O que é (e o que NÃO é) o `GenetecConnectionManager`

### **✅ O que ele é**

`GenetecConnectionManager` **não é algo da Genetec**  
👉 é um **padrão arquitetural seu** (wrapper/facade)

Ele normalmente:

* Gerencia **uma única instância de `Engine`**  
* Controla **login / logoff**  
* Gerencia **reconexão**  
* Centraliza **estado da conexão**  
* Evita múltiplas conexões concorrentes

### **❌ O que ele não é**

* ❌ Não é socket  
* ❌ Não abre porta TCP  
* ❌ Não substitui `Engine`  
* ❌ Não fala direto com a rede

### ✅ `GenetecConnectionManager`

**Observação**: isso é arquitetura, não SDK interno

| public class GenetecConnectionManager { 	private Engine \_engine; 	public Engine Engine \=\> \_engine; 	public async Task ConnectAsync() 	{     	if (\_engine \!= null && \_engine.IsConnected)         	return;     	\_engine \= new Engine();     	var result \= await \_engine.LogOnAsync(         	"server",         	"user",         	"password"     	);     	if (result \!= ConnectionStateCode.Success)         	throw new Exception("Falha ao conectar no Genetec"); 	} 	public void Disconnect() 	{     	\_engine?.LogOff();     	\_engine?.Dispose();     	\_engine \= null; 	} } |
| :---- |

## **⚠️ Erros arquiteturais comuns**

❌ Criar um `Engine` por request da API  
❌ Tratar SDK como REST/HTTP  
❌ Tentar “pingar” conexão via socket  
❌ Achar que Web SDK \== Platform SDK  
❌ Rodar SDK em thread curta

# **Autenticar pelo SDK**

Para **autenticar pelo `Engine`** (Platform SDK) no **.NET Framework**, você faz o logon no **Directory** do Security Center usando **usuário/senha** e garantindo que o ambiente tenha **SDK instalado \+ certificado SDK \+ licença/permite logon via SDK**. O ponto central é: **tudo passa pelo `Engine`**.

Abaixo vai um guia bem prático (com código), incluindo os requisitos que mais causam erro.

---

## **1\) Pré‑requisitos para autenticar (antes do código)**

### **✅ No seu computador (onde o app roda)**

* **Security Center SDK instalado** (para apps externas). [\[github-wiki-see.page\]](https://github-wiki-see.page/m/Genetec/DAP/wiki/Web-SDK-Getting-Started)  
* Referências usando `$(GSC_SDK)\Genetec.Sdk.dll` e **CopyLocal=False** (`<Private>False</Private>`). [\[github-wiki-see.page\]](https://github-wiki-see.page/m/Genetec/DAP/wiki/Web-SDK-Getting-Started)

### **✅ No Security Center (servidor)**

* Um usuário válido (Directory).  
* O usuário precisa do privilégio **“Log on using the SDK”** (ou equivalente no modelo de privilégios).  
* **Certificado do SDK** (arquivo `.cert`) disponível para o seu app (geralmente em uma pasta `Certificates` ao lado do executável). [\[github.com\]](https://github.com/Genetec/Security-Center-SDK-Samples)  
* Licença do Security Center deve aceitar o certificado/part number do SDK. [\[github.com\]](https://github.com/Genetec/Security-Center-SDK-Samples)

A documentação do DAP destaca que o `Engine` exige **certificado do SDK**, **credenciais válidas com privilégio de logon via SDK** e **acesso ao Directory**. [\[github.com\]](https://github.com/Genetec/Security-Center-SDK-Samples)

## 

## 

## 

## 

## **2\) Autenticação básica com `Engine` (usuário/senha)**

Exemplo .NET Framework (async). Ajuste `server`, `username`, `password`.

| using System; using System.Threading.Tasks; using Genetec.Sdk; public class GenetecAuthenticator { 	private readonly Engine \_engine \= new Engine(); 	public async Task LogonAsync(string server, string username, string password) 	{     	// Conecta/autentica no Directory     	var result \= await \_engine.LogOnAsync(server, username, password);     	if (result \!= ConnectionStateCode.Success)         	throw new InvalidOperationException($"Falha no logon: {result}");     	// A partir daqui você está autenticado e pode acessar entidades, eventos, reports etc.     	Console.WriteLine("Logon OK\!"); 	} 	public void Logoff() 	{     	\_engine.LogOff();     	\_engine.Dispose(); 	} } |
| :---- |

Esse fluxo (instanciar `Engine` \+ chamar `LogOnAsync`) é o padrão recomendado pelo material do DAP para operações via Platform SDK

## 

## **3\) Capturar eventos de conexão (reconectar / diagnosticar)**

| using Genetec.Sdk; public class GenetecConnectionMonitor { 	private readonly Engine \_engine \= new Engine(); 	public GenetecConnectionMonitor() 	{     	\_engine.ConnectionStateChanged \+= (s, e) \=\>     	{         	// Útil para logs: Connecting, Connected, Disconnected etc.         	Console.WriteLine($"Estado: {e.StateCode}");     	}; 	} } |
| :---- |

O `Engine` é o ponto de entrada para conexão, cache de entidades e eventos do sistema.

## **4\) Onde entra o certificado SDK?**

Você normalmente **não “passa o .cert” no LogOnAsync**.  
O runtime do SDK procura/usa o certificado conforme a configuração/padrão do SDK (por exemplo, arquivo em pasta `Certificates` ao lado do `.exe`, conforme guia “SDK Certificates” citado na visão geral da plataforma).

Se o certificado estiver ausente/incorreto, os sintomas comuns são:

* logon falha mesmo com credenciais corretas  
* mensagens de “not allowed” / “privilege” / “certificate” (dependendo do caso)

## **5\) Erros comuns ao autenticar (e como resolver)**

### **❌ `Success` não vem (falha no logon)**

Causas típicas:

1. Usuário sem privilégio **logon via SDK**.   
2. Certificado SDK ausente/inválido (ou licença não contempla).  
3. Sem acesso de rede ao **Directory**.

### **❌ `Genetec.Sdk.dll not found` (nem chega a logar)**

* SDK não instalado ou referências incorretas.  
* Garanta `GSC_SDK` e `<Private>False</Private>` / CopyLocal=False

## **6\) Padrão recomendado na sua arquitetura (Worker \+ API interna)**

Para .NET Framework com Genetec:

* **Worker (Windows Service)** mantém o `Engine` logado (conexão longa).  
* A **API interna** não abre conexão no Genetec por request; ela consulta dados do worker (DB/cache) ou dispara comandos.  
  Isso evita múltiplas conexões e problemas de estabilidade.

(Se você quiser, eu te passo um esqueleto de `GenetecConnectionManager` com *reconnect/backoff* e fila de comandos.)

e