defmodule DocuSign do
  @moduledoc """
  Documentation for DocuSign.

  ## INVALID_REQUEST_BODY Fix

  Version 1.3.1 includes a fix for the INVALID_REQUEST_BODY errors that occur when using
  embedded signing functionality. The fix implements a ModelCleaner module that recursively 
  removes nil values from request bodies before sending them to the DocuSign API.

  This fix is applied automatically to all API calls and requires no changes to your existing code.
  """
end
