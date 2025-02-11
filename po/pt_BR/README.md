# Português Brasileiro no manpages-l10n

Este documento busca registrar dicas, comandos e mais para facilitar o
trabalho de tradução de páginas man para português brasileiro.

Veja também [CONTRIBUTING.md](../../CONTRIBUTING.md) para informações oficiais.

## Comandos para listar páginas man para traduzir

Para listar apenas arquivos com tradução em 80% ou mais
(requer translate-toolkit instalado):

```shell
pocount --incomplete --short man*/*.po | sed 's/\x1b\[[0-9;]*m//g' | sort -gk10 | grep '| [8-9][0-9].[0-9]*%t'
```

Para listar os 30 primeiros arquivos PO mais traduzidos, mas que ainda
não estão 100% traduzidos:

```shell
pocount --incomplete --short man*/*.po | sed 's/\x1b\[[0-9;]*m//g' | sort -gk10 | tail -n 30
```

Listar situação da tradução de páginas man do Arch Linux:

```shell
sudo pacman -Fy
pkgs="archinstall arch-install-scripts devtools mkinitcpio namcap netctl pacman pacman-contrib"
for pkg in $pkgs; do
  echo -e "\nPacote $pkg"
  mans=$(pacman -Fl $pkg | grep -E '/man/.*\.gz' | sed 's|.*/man/man[0-9]/||;s|\.gz||' | sort)
  for man in $mans; do
    name=${man%.*}
    num=${man##*.}
    [ -L "/usr/share/man/man${num}/${name}.${num}.gz" ] && continue
    po="man${num}/${name}.${num}.po"
    if [ -f "$po" ]; then
      msgfmt -cvvo /dev/null $po
    else
      upstream_man="../../upstream/archlinux/man${num}/${name}.${num}"
      if [ -f "$upstream_man" ]; then
        echo "No PO yet, run '../create-new-translation.sh ${po}'"
      else
        echo "-> '${man}' is not available for translation"
      fi
    fi
  done
done
```

## Passo a passo dos comandos de atualização da tradução

Segue abaixo uma sequência de comandos que eu (Rafael) uso para fazer as
traduções em lote, ou seja, de vários arquivos PO.

Os comandos abaixo presumem que no seu terminal/console você encontra-se no
diretório `po/pt_BR/` (diretório específico para o idioma).

1.  Adicione a este array de Bash os arquivos PO que você acabou de traduzir
e cujas alterações devem ser ser adicionados ao repositório Git. Não use
vírgulas, só nova linha.

```shell
pofiles=(
    man1/um-arquivo.po
    man5/outro-arquivo.po
    ...
)
```

2. Depois de traduzido, gere a página man de todos os arquivos PO para
certificar de que não deixou passar nenhum erro de sintaxe que vá criar
empecilho no empacotamento do projeto manpages-l10n.

```shell
upstreams=$(find ../../upstream/ -maxdepth 1 -mindepth 1 -type d | sed 's|.*/||' | sort)
for po in ${pofiles[*]}; do
    for distro in $upstreams; do
        /usr/bin/msgfmt -co /dev/null $po && \
        [ -f ../../upstream/$distro/${po%%.po} ] && \
        ../generate-manpage.sh $distro $po && \
        echo "  $distro/${po%%.po}"
    done
done
```

3. Finalizada a tradução, atualize os compêndios (do diretório `common/`):

```shell
for po in ${pofiles[*]}; do
    /usr/bin/msgfmt -co /dev/null $po && \
    ../use-for-compendium.sh $po
done && \
../update-translations.sh
```

4. Para todos os arquivos que foram traduzidos, faça commits adicionando as
alterações (um commit por arquivo):

```shell
for po in ${pofiles[*]}; do
    git add $po && \
    git commit -m "[pt_BR] Complete $po" $po
done
```

5. Agora, atualize os compêndios com as alterações nos commits:

```shell
git commit -m "[pt_BR] Update compendia

Updated after translating these files:
   $(echo ${pofiles[*]} | sed 's| |\n   |g')" \
    common/min-*-occurences.po
```

6. Por fim, faça commit dos restantes dos arquivos PO que foram atualizados
pelos compêndios:

```shell
git add -u man*/*.po && \
git commit -m "[pt_BR] Update translations from compendium"
```

