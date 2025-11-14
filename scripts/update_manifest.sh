find ../ -name '*.ebuild' | xargs -I '{}' sudo ebuild '{}' manifest
