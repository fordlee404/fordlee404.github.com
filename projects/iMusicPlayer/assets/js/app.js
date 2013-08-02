(function() {
  var $fileInput, $nextBtn, $pauseBtn, $playBtn, $player, $preBtn, $uploadBtn, createNotify, currentTag, musicList, playMusic, reader;

  musicList = [];

  currentTag = 0;

  reader = new FileReader();

  $player = $('#music_data');

  $uploadBtn = $('#control-upload');

  $preBtn = $('#control-backward');

  $nextBtn = $('#control-forward');

  $playBtn = $('#control-play');

  $pauseBtn = $('#control-pause');

  $fileInput = $('#upload_music');

  $(reader).bind('load', function() {
    return $player.attr('src', this.result);
  });

  $player.bind('ended', function(e) {
    return $nextBtn.trigger('click');
  });

  createNotify = function(music_name) {
    var notify;
    if (!window.Notification) {
      return false;
    }
    if (window.Notification.permission === 'default') {
      return window.Notification.requestPermission(function() {
        return createNotify();
      });
    } else if (window.Notification.permission === 'granted') {
      notify = new Notification(music_name, {
        'tag': 'unique string'
      });
      return notify.onclose = function() {
        return console.log('Notification closed');
      };
    } else if (window.Notification.permission === 'denied') {
      return false;
    }
  };

  playMusic = function(music) {
    var $musicName, $musicPlayer, _name;
    $musicName = $('#music_name');
    $musicPlayer = $('#music_player');
    _name = music.name.split('.');
    _name.pop();
    _name = _name.join('');
    /*
    $.ajax
      type:'GET'
      url:'http://localhost:2222/iMusicPlayer/FAKE_RESPONSE/searchMusic.php'
      data:
        name: _name
        rnd: parseInt(Math.random()*1e7,10)+(new Date()).getTime()
      success: (data)->
        console.log data
    */

    createNotify(_name);
    $musicName.text(_name.split('-')[0]);
    $musicPlayer.text(_name.split('-')[1]);
    reader.readAsDataURL(music);
    $playBtn.hide();
    return $pauseBtn.show();
  };

  $fileInput.bind('change', function() {
    var music, _i, _len, _ref, _results;
    if (!$player.get(0).currentTime) {
      currentTag = musicList.length;
      playMusic(this.files[0]);
    }
    _ref = this.files;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      music = _ref[_i];
      _results.push(musicList.push(music));
    }
    return _results;
  });

  $uploadBtn.bind('click', function() {
    return $fileInput.trigger('click');
  });

  $playBtn.bind('click', function() {
    if (musicList.length === 0) {
      return $uploadBtn.trigger('click');
    } else {
      $player.get(0).play();
      $playBtn.hide();
      return $pauseBtn.show();
    }
  });

  $pauseBtn.bind('click', function() {
    $player.get(0).pause();
    $pauseBtn.hide();
    return $playBtn.show();
  });

  $preBtn.bind('click', function() {
    if (currentTag === 0) {
      currentTag = musicList.length - 1;
    } else {
      currentTag--;
    }
    return playMusic(musicList[currentTag]);
  });

  $nextBtn.bind('click', function() {
    if (currentTag === musicList.length - 1) {
      currentTag = 0;
    } else {
      currentTag++;
    }
    return playMusic(musicList[currentTag]);
  });

}).call(this);
