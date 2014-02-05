# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

(function(){
  var Fbchat = window.Fbchat = new Object();
  (Fbchat._init = function(){
  	Fbchat.source = new EventSource('/messages/events');
  	var _s = Fbchat.source;

  	_s.addEventListener( 'message', function(e){
  	  var _m = $.parseJSON(e.data);
  	  console.dir( _m );
      $('#chat').append($("<li>" + _m.name + ": " + _m.content + "</li>"));
      $('#chat').animate({ scrollTop: $('#chat').prop('scrollHeight') - $('#chat').height() }, 400);
      new app.clearMessageInputs(_m.conenction_id);
  	}, false);
  }());

  $(function(){
    var _ele = $('#message_content'),
        _eleh = $('#message_connection_id'),
        _store = window.sessionsStorage || null;

    var app = window.app = {
      clearMessageInputs: function(connection_id){
        if( connection_id == _store.connection_id ){
          _ele.val('');
        }
      },
      setConnectionId: function(){
      	console.log( _store );
      	if( !!_store && typeof _store.connectionId === 'undefined' ){
      	  var rand = Math.round( Math.random() * 100000000 );
      	  _store.connection_id = rand;
      	}
      	return _eleh.val(_store.connection_id);
      }()
    };    
  });
}(window));