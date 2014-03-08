/**
 * User: Bart
 * Date: 08/03/2014
 * Time: 00:26
 * Description:
 */

package com.bnowak.parsec.util.binding
{
import flash.utils.Dictionary;

import mx.binding.utils.ChangeWatcher;

import org.spicefactory.lib.logging.LogContext;

import org.spicefactory.lib.logging.Logger;

import org.spicefactory.lib.util.DictionaryUtil;

// TODO: this shit need unit testing

public class WatcherUtil
{

   /**
    *  @private
    */
   private static var LOG:Logger = LogContext.getLogger( WatcherUtil );

   /**
    *  @private
    */
   private static var _watchers:Dictionary;

   /**
    *  @private
    */
   public static function watch( target:Object, chain:Object, handler:Function ):ChangeWatcher
   {
      var translator:Function = function (...triggers):void
      {
         if( chain is String && target.hasOwnProperty( ( chain as String )))
         {
            try
            {
               handler.call( null, target[ chain ]);
            }catch (e:Error)
            {
               LOG.error( "{0} thrown while executing watcher binding: {1}", e.name, e.message )
            }
         }
      }
      var watcher:ChangeWatcher = ChangeWatcher.watch( target, [ chain ], translator );
      if( !_watchers )
         _watchers = new Dictionary();
      if( !_watchers[ target ])
         _watchers[ target ] = new Dictionary();
      if( !_watchers[ target ][ chain ])
         _watchers[ target ][ chain ] = new Dictionary();
      _watchers[ target ][ chain ][ handler ] = watcher;
      translator();
      return watcher;
   }

   /**
    *  @private
    */
   public static function unwatch( target:Object, chain:Object, handler:Function ):void
   {
      if( !_watchers || !_watchers[ target ] || !_watchers[ target ][ chain ] || !_watchers[ target ][ chain ][ handler ])
         return;

      ( _watchers[ target ][ chain ][ handler ] as ChangeWatcher ).unwatch();
      delete _watchers[ target ][ chain ][ handler ];
      if( DictionaryUtil.isEmpty( _watchers[ target ][ chain ] ))
         delete _watchers[ target ][ chain ];
      if( DictionaryUtil.isEmpty( _watchers[ target ]))
         delete  _watchers[ target ];
   }

   /**
    *  @private
    */
   public static function unwatchAll( target:Object ):void
   {
      if( !_watchers || !_watchers[ target ])
         return;
      for each( var chain:Dictionary in _watchers[ target ])
      {
         for each( var handler:Dictionary in _watchers[ target ][ chain ])
         {
            for each( var w:ChangeWatcher in _watchers[ target ][ chain ][ handler ])
            {
               w.unwatch();
               delete _watchers[ target ][ chain ][ handler ];
            }
            delete _watchers[ target ][ chain ][ handler ];
         }
         delete _watchers[ target ][ chain ];
      }
      delete _watchers[ target ];
   }

   /**
    *  @private
    */
   public static function isWatching( target:Object ):Boolean
   {
      return _watchers && _watchers[ target ];
   }

}
}
