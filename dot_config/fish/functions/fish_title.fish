function fish_title
  if test $_ = 'fish'
    prompt_pwd
  else
    echo (echo $_) (prompt_pwd)
  end
end
