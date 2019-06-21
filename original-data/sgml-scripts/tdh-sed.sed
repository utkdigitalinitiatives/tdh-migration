# tdh cleanup sed file
# correct <!DOCTYPE...> 
s/<!DOCTYPE\ TEI.2\ SYSTEM "\.\.\/\.\.\/Rules.*$/<!DOCTYPE TEI.2 SYSTEM "..\/rules\/teixlite.dtd">/g

# correct <availability> attribute
s/<availability\ status="FREE">/<availability>/g

# correct opening <pb> elements w/references
s/<pb\ \(n="[[:alnum:]]\{1,\}"\)>/<pb \1\/>/g
s/<pb\ \(n="\[[[:alnum:]]\{1,\}\][[:alnum:]]\{1,\}"\)>/<pb \1\/>/g
s/<pb\ \(n="\[.*\]"\)>/<pb \1\/>/g
s/<pb\ \(n="\[.*\][a-zA-Z0-9]\{1,\}"\)>/<pb \1\/>/g
s/<pb\ \(id="[[:alnum:]]\{1,\}"\ n="\[[[:alnum:]]\{1,\}\]"\)>/<pb \1\/>/g

# catch closing <pb> elements
s/<\/pb>//g

# correct opening <lb> elements
s/<lb>/<lb\/>/g

# catch closing <lb> elements
s/<\/lb>//g
