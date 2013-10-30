package com.bnowak.parsec.util.integration.parsley
{
import flash.errors.IllegalOperationError;

import org.spicefactory.lib.reflect.ClassInfo;
import org.spicefactory.lib.reflect.Method;
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.context.provider.ObjectProvider;
import org.spicefactory.parsley.core.context.provider.Provider;
import org.spicefactory.parsley.core.messaging.receiver.MessageTarget;
import org.spicefactory.parsley.core.scope.ScopeName;
import org.spicefactory.parsley.messaging.receiver.DefaultMessageHandler;
import org.spicefactory.parsley.messaging.receiver.MessageReceiverInfo;
import org.spicefactory.parsley.messaging.receiver.MethodReceiver;

/***************************************************************************
 *
 *   @author Bart
 *   @created 18 Oct 2013
 *
 *   Helper class for registering message handlers in AS only classes
 *
 ***************************************************************************/

public class MessageHandlerProvider
{

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   /**
    *  registers new MessageHandler
    */
   public static function register(
      context:Context,
      messageType:Class,
      receiver:Object,
      methodName:String ):MessageTarget
   {
      var info:MessageReceiverInfo = new MessageReceiverInfo();
      info.type = ClassInfo.forClass( messageType );
      var messageHandler:DefaultMessageHandler = new DefaultMessageHandler( info );
      var op:ObjectProvider                    = Provider.forInstance( receiver );
      var m:Method                             = ClassInfo.forInstance( receiver ).getMethod( methodName );
      if( !m )
         throw IllegalOperationError("Invalid method " + methodName + " specified");
      MethodReceiver( messageHandler ).init( op, m );
      context.scopeManager.getScope( ScopeName.GLOBAL ).messageReceivers.addTarget( MessageTarget( messageHandler ) );
      return messageHandler as MessageTarget;
   }

   /**
    *  de-registers a MessageTarget
    */
   public static function deregister( context:Context, target:MessageTarget ):void
   {
      context.scopeManager.getScope( ScopeName.GLOBAL ).messageReceivers.removeTarget( target );
   }

}
}
