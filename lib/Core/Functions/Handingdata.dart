import 'package:ExiirEV/Core/Class/StatusRequest.dart';

handlingData(response)
{
  if(response is StatusRequest) return response;
  else return StatusRequest.success;
}