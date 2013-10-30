package com.bnowak.parsec.util.integration.parsley
{
import flash.display.DisplayObject;
import flash.errors.IllegalOperationError;

import org.spicefactory.parsley.view.ContextLookup;
import org.spicefactory.parsley.view.ParentContext;

/***************************************************************************
 *
 *   @author Bart
 *   @created 18 Oct 2013
 *
 *   Helper class for performing context lookups in AS only classes
 *
 ***************************************************************************/

public class ContextLookupHelper
{

   //--------------------------------------------------------------------------
   //
   //  Methods
   //
   //--------------------------------------------------------------------------

   /**
    *  looks up context for a given view
    *  @param contextFoundHandler method reference. should take Context as a single param
    */
   public static function lookup( view:DisplayObject, contextFoundHandler:Function ):ContextLookup
   {
      return ParentContext.view( view ).available( contextFoundHandler ).error( contextNotFoundHandler ).execute();
   }

   /**
    *  @private
    *  callback method for context lookup failure
    */
   private static function contextNotFoundHandler():void
   {
      throw new IllegalOperationError( "Context not found in view hierachy, cannot proceed!" );
   }

}
}
