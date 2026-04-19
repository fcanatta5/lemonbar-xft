<div align="center">

# 🍋 lemonbar-xft

### Um fork moderno, corrigido e melhorado do **lemonbar** com suporte a **Xft**, **Fontconfig** e renderização leve para X11.

[![Language](https://img.shields.io/badge/language-C-blue.svg)](./lemonbar.c)
[![Standard](https://img.shields.io/badge/C-C11-00599C.svg)](https://en.wikipedia.org/wiki/C11_(C_standard_revision))
[![Platform](https://img.shields.io/badge/platform-X11-222222.svg)](https://www.x.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE)
[![Build](https://img.shields.io/badge/build-Makefile-lightgrey.svg)](./Makefile)

</div>

---

## 📌 Sobre o projeto

**lemonbar-xft** é um fork do clássico `lemonbar`, uma barra extremamente leve para ambientes gráficos baseados em **X11**.

Este fork mantém a filosofia original do projeto — simplicidade, baixo consumo e controle total via texto — mas adiciona e preserva suporte a:

- fontes modernas via **Xft**;
- seleção de fontes via **Fontconfig**;
- renderização de caracteres Unicode;
- múltiplas fontes;
- áreas clicáveis;
- múltiplos monitores via **RandR** e, opcionalmente, **Xinerama**;
- formatação inline em tempo real;
- build modernizada em **C11**.

Este repositório foi corrigido, atualizado e melhorado para ser mais robusto, portável e agradável de manter.

---

## ✨ Destaques

- 🚀 **Leve e direto**: uma barra minimalista escrita em C.
- 🎨 **Suporte a Xft/Fontconfig**: use fontes modernas, anti-aliased e especificadas por nome.
- 🌍 **Melhor suporte Unicode**: renderização aprimorada para caracteres fora do BMP quando usando Xft.
- 🖱️ **Áreas clicáveis**: crie segmentos interativos na barra.
- 🖥️ **Multi-monitor**: suporte a RandR e Xinerama opcional.
- 🔧 **Build simples**: Makefile limpo, com dependências via `pkg-config`.
- 🧪 **Sanity check sem DISPLAY**: `make check` valida o CLI básico sem exigir sessão X.
- 🧼 **Código revisado**: correções de parsing, segurança, portabilidade e warnings.

---

## 🧱 Dependências

Para compilar este fork, você precisa de:

- compilador C compatível com **C11**;
- `make`;
- `pkg-config`;
- headers de desenvolvimento para:
  - `xcb`;
  - `xcb-randr`;
  - `x11`;
  - `x11-xcb`;
  - `xft`;
  - `fontconfig`;
  - `freetype2`.

### Arch Linux / EndeavourOS / Manjaro

```bash
sudo pacman -S --needed base-devel pkgconf libxcb libx11 libxft fontconfig freetype2
```

### Debian / Ubuntu / Linux Mint

```bash
sudo apt update
sudo apt install build-essential pkg-config \
  libxcb1-dev libxcb-randr0-dev \
  libx11-dev libx11-xcb-dev \
  libxft-dev libfontconfig1-dev libfreetype6-dev
```

Para suporte opcional a Xinerama:

```bash
sudo apt install libxcb-xinerama0-dev
```

### Fedora

```bash
sudo dnf install gcc make pkgconf-pkg-config \
  libxcb-devel libX11-devel libXft-devel \
  fontconfig-devel freetype-devel
```

---

## 📦 Instalação

Clone o repositório:

```bash
git clone https://github.com/fcanatta5/lemonbar-xft.git
cd lemonbar-xft
```

Compile:

```bash
make
```

Instale no sistema:

```bash
sudo make install
```

Por padrão, o binário é instalado em:

```text
/usr/bin/lemonbar
```

E a man page em:

```text
/usr/share/man/man1/lemonbar.1
```

---

## ⚙️ Compilação com Xinerama

O suporte a Xinerama é opcional.

Para compilar com Xinerama:

```bash
make clean
make WITH_XINERAMA=1
```

Para instalar essa versão:

```bash
sudo make install WITH_XINERAMA=1
```

---

## 🧪 Verificação rápida

Este fork inclui um alvo de teste mínimo:

```bash
make check
```

Esse teste executa:

```bash
./lemonbar -h
```

A validação não exige um servidor X ativo, pois o parsing de argumentos foi corrigido para ocorrer antes da tentativa de conexão com o display.

---

## 🚀 Uso básico

O `lemonbar` lê texto da entrada padrão e desenha esse conteúdo em uma barra no X11.

Exemplo simples:

```bash
echo "Olá, lemonbar-xft" | lemonbar -p
```

Exemplo com fonte Xft, cores e geometria:

```bash
echo " lemonbar-xft " | lemonbar \
  -p \
  -g x28 \
  -f "JetBrainsMono Nerd Font:size=10" \
  -B "#cc1e1e2e" \
  -F "#cdd6f4"
```

Exemplo de barra inferior:

```bash
echo " barra inferior " | lemonbar -p -b -g x28
```

---

## 🧾 Exemplo de status bar

Crie um script chamado `statusbar.sh`:

```bash
#!/usr/bin/env bash

while true; do
  clock="$(date '+%d/%m/%Y %H:%M:%S')"
  kernel="$(uname -r)"

  printf "%%{l} 🍋 lemonbar-xft %%{c} 🐧 %s %%{r}  %s \n" "$kernel" "$clock"

  sleep 1
done
```

Dê permissão de execução:

```bash
chmod +x statusbar.sh
```

Execute:

```bash
./statusbar.sh | lemonbar \
  -p \
  -g x28 \
  -f "JetBrainsMono Nerd Font:size=10" \
  -B "#cc11111b" \
  -F "#cdd6f4"
```

---

## 🖱️ Áreas clicáveis

O `lemonbar` permite criar regiões clicáveis usando blocos `%{A...}`.

Exemplo:

```bash
echo '%{A1:notify-send "lemonbar-xft" "Clique detectado":}Clique aqui%{A}' | lemonbar -p | sh
```

Neste exemplo:

- `A1` indica clique com botão esquerdo;
- o texto entre `%{A1:...:}` e `%{A}` vira uma área clicável;
- ao clicar, o comando é enviado para `stdout`;
- o pipe para `sh` executa o comando.

> ⚠️ Use `| sh` apenas com comandos gerados por você. Não execute conteúdo não confiável.

---

## 🎨 Formatação inline

O `lemonbar` usa blocos de formatação no estilo:

```text
%{comando}
```

Alguns comandos úteis:

| Sintaxe | Função |
|---|---|
| `%{l}` | Alinha o texto à esquerda |
| `%{c}` | Alinha o texto ao centro |
| `%{r}` | Alinha o texto à direita |
| `%{F#rrggbb}` | Define a cor de primeiro plano |
| `%{B#rrggbb}` | Define a cor de fundo |
| `%{U#rrggbb}` | Define a cor da linha inferior/superior |
| `%{F-}` | Reseta a cor de primeiro plano |
| `%{B-}` | Reseta a cor de fundo |
| `%{U-}` | Reseta a cor da underline/overline |
| `%{+u}` | Ativa underline |
| `%{-u}` | Desativa underline |
| `%{+o}` | Ativa overline |
| `%{-o}` | Desativa overline |
| `%{T1}` | Usa a fonte do slot 1 |
| `%{T-}` | Retorna ao fallback automático de fontes |
| `%{O10}` | Avança 10 pixels |
| `%{A:cmd:}` | Abre uma área clicável |
| `%{A}` | Fecha uma área clicável |
| `%{S+}` | Próximo monitor |
| `%{S-}` | Monitor anterior |

Exemplo:

```bash
echo '%{l}%{F#89b4fa}left%{F-}%{c}%{+u}center%{-u}%{r}%{B#313244}right%{B-}' | lemonbar -p
```

---

## 🔠 Fontes

Este fork suporta fontes via **Xft** e **Fontconfig**.

Exemplo com uma fonte:

```bash
lemonbar -f "JetBrainsMono Nerd Font:size=10"
```

Exemplo com múltiplas fontes:

```bash
lemonbar \
  -f "JetBrainsMono Nerd Font:size=10" \
  -f "Noto Color Emoji:size=10" \
  -f "Symbols Nerd Font:size=10"
```

O projeto possui um número máximo fixo de slots de fonte definido no código como:

```c
#define MAX_FONT_COUNT 5
```

---

## 🎛️ Opções principais

| Opção | Descrição |
|---|---|
| `-h` | Mostra a ajuda e encerra |
| `-g WxH+X+Y` | Define a geometria da barra |
| `-b` | Posiciona a barra na parte inferior da tela |
| `-d` | Força dock sem depender do window manager |
| `-f FONT` | Define uma fonte |
| `-a N` | Define o número de áreas clicáveis |
| `-p` | Mantém a barra aberta após o fechamento do stdin |
| `-n NAME` | Define o valor de `WM_NAME` |
| `-u N` | Define a espessura da underline/overline |
| `-B COLOR` | Define a cor de fundo |
| `-F COLOR` | Define a cor de primeiro plano |
| `-U COLOR` | Define a cor da underline/overline |
| `-o N` | Aplica offset vertical no texto |

Formatos de cor aceitos:

```text
#rgb
#rrggbb
#aarrggbb
```

---

## 🛠️ Alvos do Makefile

| Alvo | Ação |
|---|---|
| `make` | Compila o binário |
| `make debug` | Compila com flags extras de debug |
| `make check` | Executa teste mínimo de CLI |
| `make doc` | Gera a man page a partir de `README.pod` |
| `make install` | Instala binário e man page |
| `make uninstall` | Remove binário e man page |
| `make clean` | Remove artefatos de build |

Instalação em prefixo customizado:

```bash
sudo make install PREFIX=/usr/local
```

Instalação usando `DESTDIR`, útil para empacotamento:

```bash
make install DESTDIR="$pkgdir" PREFIX=/usr
```

---

## ✅ Correções e melhorias aplicadas neste fork

Este fork recebeu uma revisão técnica com foco em robustez, portabilidade e manutenção.

Principais pontos corrigidos:

### 1. `lemonbar -h` sem servidor X

Antes, o programa tentava abrir conexão com o X server antes de processar `-h`.

Agora, o parsing da CLI ocorre antes da conexão com o display, permitindo:

```bash
./lemonbar -h
```

mesmo em ambientes sem `DISPLAY`.

### 2. Reset correto do estado de formatação

Cores, atributos e fonte selecionada não vazam mais de uma linha de entrada para a próxima.

Cada nova linha restaura:

- foreground;
- background;
- underline;
- atributos;
- seleção de fonte;
- offset vertical.

### 3. Parser de geometria mais estrito

Entradas malformadas agora são rejeitadas corretamente, em vez de serem aceitas parcialmente.

### 4. Parser de cores mais portável

O parsing de `#rgb`, `#rrggbb` e `#aarrggbb` foi refeito de forma explícita, evitando comportamento pouco portável com casts diretos.

### 5. Áreas clicáveis mais seguras

Os limites de áreas clicáveis foram trocados de bitfields de 16 bits para `int`, reduzindo risco de truncamento em geometrias grandes.

### 6. Unicode fora do BMP com Xft

O decoder UTF-8 agora suporta codepoints até `U+10FFFF`.

Quando usando Xft, a renderização usa `XftDrawString32()` para lidar melhor com caracteres Unicode além do BMP.

### 7. Melhor tratamento de alocação

Falhas de alocação em estruturas como `WM_CLASS` agora são tratadas de forma mais segura.

### 8. Ordenação de monitores mais clara

A ordenação dos monitores foi simplificada para usar `x` e depois `y`, tornando o comportamento mais previsível.

### 9. Linkagem mais limpa

A dependência desnecessária de `zlib` foi removida.

### 10. Build modernizada

O projeto agora compila como **C11** e possui alvo `make check`.

---

## 🧪 Validação técnica

A base atual foi validada com:

```bash
make
make check
make WITH_XINERAMA=1
make debug
cppcheck --enable=warning,style,performance,portability --std=c11
```

Também foi validada execução básica com `Xvfb`, texto formatado e caractere Unicode fora do BMP.

---

## 🧭 Estrutura do repositório

```text
.
├── ANALISE.md      # Notas técnicas das correções e melhorias
├── LICENSE         # Licença MIT
├── Makefile        # Build, instalação, documentação e testes
├── README.md       # Documentação principal do projeto
├── README-xft      # Notas históricas sobre o fork Xft
├── README.pod      # Documentação usada para gerar man page
└── lemonbar.c      # Código-fonte principal
```

---

## 🔍 Filosofia do projeto

Este fork segue três princípios:

1. **Manter o lemonbar simples**  
   Sem frameworks, sem daemon pesado, sem configuração complexa.

2. **Melhorar sem descaracterizar**  
   As correções buscam preservar o comportamento clássico do lemonbar.

3. **Ser útil em setups reais**  
   Especialmente para usuários de window managers minimalistas como `dwm`, `bspwm`, `i3`, `openbox`, `awesomewm`, `herbstluftwm` e sessões X11 customizadas.

---

## 🪟 Integração com window managers

Exemplo simples para iniciar com `bspwm`, `dwm`, `openbox` ou `.xinitrc`:

```bash
~/.config/lemonbar/statusbar.sh | lemonbar \
  -p \
  -g x28 \
  -f "JetBrainsMono Nerd Font:size=10" \
  -B "#cc11111b" \
  -F "#cdd6f4" &
```

Em `.xinitrc`:

```bash
~/.config/lemonbar/start.sh &
exec dwm
```

---

## 🧹 Desinstalação

Se instalado via `make install`:

```bash
sudo make uninstall
```

Se foi usado um prefixo customizado:

```bash
sudo make uninstall PREFIX=/usr/local
```

---

## 🚧 Limitações conhecidas

Este projeto continua sendo propositalmente simples.

Algumas limitações atuais:

- o buffer de leitura de linha ainda é fixo;
- emojis complexos com ZWJ e clusters grapheme não recebem shaping avançado;
- fontes legadas XCB continuam limitadas a UCS-2;
- shaping completo exigiria bibliotecas como HarfBuzz ou Pango;
- testes unitários reais exigiriam separar partes puras do código em módulos próprios.

---

## 🤝 Contribuindo

Contribuições são bem-vindas.

Sugestões úteis:

- correções de build em distribuições diferentes;
- melhorias de documentação;
- testes para parsing de cor, geometria e UTF-8;
- revisão de compatibilidade com diferentes window managers;
- melhorias sem comprometer a leveza do projeto.

Fluxo sugerido:

```bash
git clone https://github.com/fcanatta5/lemonbar-xft.git
cd lemonbar-xft
git checkout -b minha-melhoria
# faça suas alterações
make
make check
git commit -m "Descreve minha melhoria"
```

Depois abra um Pull Request.

---

## 🙏 Créditos

- Projeto original: **lemonbar**, também conhecido historicamente como `bar`, por **The Lemon Man**.
- Suporte a RandR: contribuição atribuída a `jvvv`.
- Suporte a Xinerama: contribuição atribuída a `Stebalien`.
- Suporte a áreas clicáveis: baseado em contribuições de `u-ra`.
- Suporte Xft/Fontconfig preservado a partir de forks e contribuições da comunidade.
- Manutenção, correções e melhorias deste fork: **Fernando Canatta**.

---

## 📄 Licença

Este projeto é distribuído sob a licença **MIT**.

Veja o arquivo [LICENSE](./LICENSE) para mais detalhes.

---

<div align="center">

**lemonbar-xft** — uma barra leve, elegante e hackeável para X11.

Feito para quem gosta de controlar cada pixel do próprio desktop.

</div>
