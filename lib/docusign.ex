defmodule DocuSign do
  @moduledoc """
  Documentation for DocuSign.

  ## INVALID_REQUEST_BODY Fix

  This library includes a fix for the INVALID_REQUEST_BODY errors that can occur when using
  embedded signing functionality. The fix implements a ModelCleaner module that recursively
  removes nil values from request bodies before sending them to the DocuSign API.

  This fix is applied automatically to all API calls and requires no changes to your existing code.

  ## JSON Library

  The DocuSign library uses Jason for all JSON encoding and decoding operations including API
  request bodies, model serialization, and authentication.

  Jason is included as a dependency, so you don't need to specify it explicitly
  in your application.
  """
end
