function fish_title
  if test $_ = 'fish'
    pwd
  else
    echo $_
  end
end
