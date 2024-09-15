#!/usr/bin/env bash
_g_name() { 
    local _url="${1:?}";
    local name_1 name_2;
    if echo "$_url" | fgrep --color=no -q '^'; then
        read -r name_1 name_2 < <(awk -F'^' '{print $1, $2}' <<< "$_url") && echo -n "${name_1} "
        name_1=$(echo "$name_1" | awk -F'/' '{print $NF}');
        echo "'${name_2}/${name_1}'"
    else
        read -r name_2 name_1 < <(awk -F'/' '{for (i = NF; i > 3; i = i - 1) printf("%s ", $i);}' <<< "$_url")
        echo "$_url '@${name_1}/${name_2}'"
    fi
}
git-clone-debug() { GIT_CURL_VERBOSE=1 GIT_TRACE=1 git-clone "$@"; }
git-clone() {
    while IFS= read -r line; do
        [[ -z "$line" ]] && continue;
        [[ -f /tmp/stop ]] && break;
        local gline="$(_g_name "$line")";
        local dir="$(echo "$gline" | awk -F\' '{print $2,$4}')";
        local OPWD="$PWD"
        if [[ -d "$dir" ]]; then
            cd "$dir" && git fetch --all; cd "$OPWD"
        fi
        eval "git clone --depth=1 --no-checkout $gline"
    done
}
echo -n '
https://github.com/rails/rails
https://github.com/redis/redis-rb^Ruby/Cache
https://github.com/rspec/rspec^Ruby/Test
https://github.com/prawnpdf/prawn^Ruby/PDF
https://github.com/brianmario/mysql2^Ruby/DbClient
https://github.com/jeremyevans/sequel^Ruby/SQL
https://github.com/codahale/bcrypt-ruby^Ruby/PasswordHash
https://github.com/minimagick/minimagick^Ruby/Image
https://github.com/symfony/symfony^PHP/Framework
https://github.com/vuejs/vue^JS/Framework
' | git-clone
RESULT="
git clone --depth=1 --no-checkout https://github.com/rails/rails '@rails/rails'
git clone --depth=1 --no-checkout https://github.com/redis/redis-rb 'Ruby/Cache/redis-rb'
git clone --depth=1 --no-checkout https://github.com/rspec/rspec 'Ruby/Test/rspec'
git clone --depth=1 --no-checkout https://github.com/prawnpdf/prawn 'Ruby/PDF/prawn'
git clone --depth=1 --no-checkout https://github.com/brianmario/mysql2 'Ruby/DbClient/mysql2'
git clone --depth=1 --no-checkout https://github.com/jeremyevans/sequel 'Ruby/SQL/sequel'
git clone --depth=1 --no-checkout https://github.com/codahale/bcrypt-ruby 'Ruby/PasswordHash/bcrypt-ruby'
git clone --depth=1 --no-checkout https://github.com/minimagick/minimagick 'Ruby/Image/minimagick'
git clone --depth=1 --no-checkout https://github.com/symfony/symfony 'PHP/Framework/symfony'
git clone --depth=1 --no-checkout https://github.com/vuejs/vue 'JS/Framework/vue'
"
