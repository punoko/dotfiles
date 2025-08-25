if status is-interactive && command --query gpgconf
    gpgconf --launch gpg-agent
    set --export SSH_AUTH_SOCK "$HOME/.gnupg/S.gpg-agent.ssh"
end
