musicList = []
currentTag = 0
reader = new FileReader()
$player = $('#music_data')
$uploadBtn = $('#control-upload')
$preBtn = $('#control-backward')
$nextBtn = $('#control-forward')
$playBtn = $('#control-play')
$pauseBtn = $('#control-pause')
$fileInput = $('#upload_music')

# 加载音乐数据
$(reader).bind 'load',->
  $player.attr 'src',this.result

# 一首音乐播放结束时事件
$player.bind 'ended',(e)->
  $nextBtn.trigger 'click'

# Notification Center
createNotify = (music_name)->
  # check for notification compatibility
  if !window.Notification
    # if browser version is unsupported, be silent
    return false

  # if the user has been asked to grant or deny notifications from this domain
  if window.Notification.permission is 'default'
    window.Notification.requestPermission ->
      # callback this function once a permission level has been set
      createNotify()
  # if the user has granted permission for this domain to send notification
  else if window.Notification.permission is 'granted'
    notify = new Notification music_name,{
      # 'body': 'Jill would like to add you as a friend'
      # prevent duplicate notification
      'tag': 'unique string'
    }
    # callback function when the notification is closed
    notify.onclose=->
      console.log 'Notification closed'
  # if the user does not want notifications to come from this domain
  else if window.Notification.permission is 'denied'
    # be silent
    return false

# 播放音乐
playMusic = (music)->
  $musicName = $('#music_name')
  $musicPlayer = $('#music_player')
  _name = music.name.split '.'
  _name.pop()
  _name = _name.join ''
  ###
  $.ajax
    type:'GET'
    url:'http://localhost:2222/iMusicPlayer/FAKE_RESPONSE/searchMusic.php'
    data:
      name: _name
      rnd: parseInt(Math.random()*1e7,10)+(new Date()).getTime()
    success: (data)->
      console.log data
  ###
  createNotify _name
  $musicName.text _name.split('-')[0]
  $musicPlayer.text _name.split('-')[1]
  reader.readAsDataURL music
  # 隐藏播放按钮
  $playBtn.hide()
  # 显示暂停按钮
  $pauseBtn.show()


# 上传音乐
$fileInput.bind 'change',->
  # 当没有音乐正在播放时，开始播放刚刚上传的音乐
  if !$player.get(0).currentTime
    currentTag = musicList.length
    playMusic this.files[0]
  # 将新上传的音乐添加进列表
  musicList.push music for music in this.files

# 操作：上传
$uploadBtn.bind 'click',->
  $fileInput.trigger 'click'

# 操作：播放
$playBtn.bind 'click',->
  if musicList.length is 0 
    # 如果播放列表没有音乐，则打开上传对话框
    $uploadBtn.trigger 'click'
  else
    # 如果播放列表中有音乐，则开始播放
    $player.get(0).play()
    # 隐藏播放按钮
    $playBtn.hide()
    # 显示暂停按钮
    $pauseBtn.show()

$pauseBtn.bind 'click',->
  # 暂停音乐
  $player.get(0).pause()
  # 隐藏暂停按钮
  $pauseBtn.hide()
  # 显示播放按钮
  $playBtn.show()

# 操作：上一首
$preBtn.bind 'click',->
  if currentTag is 0 then currentTag=musicList.length-1 else currentTag--
  playMusic musicList[currentTag]

# 操作：下一首
$nextBtn.bind 'click',->
  if currentTag is musicList.length-1 then currentTag=0 else currentTag++
  playMusic musicList[currentTag]
