package com.bnowak.parsec.util.integration.parsley
{
import org.spicefactory.parsley.core.context.Context;
import org.spicefactory.parsley.core.messaging.impl.MessageDispatcher;
import org.spicefactory.parsley.core.scope.ScopeName;

/***************************************************************************
 *
 *   @author Bart
 *   @created 18 Oct 2013
 *
 *   Helper class for crreating message dispatchers in AS only classes
 *
 ***************************************************************************/

public class MessageDispatcherProvider
{

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   /**
    *  @return new message dispatcher function instance configured for a given Context
    */
   public static function newInContext( context:Context ):MessageDispatcher
   {
      return new MessageDispatcher( context.scopeManager, ScopeName.GLOBAL );
   }
}
}
