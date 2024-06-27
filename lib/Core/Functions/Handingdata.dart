import 'package:exiir3/Core/Class/StatusRequest.dart';

handlingData(response)
{
  if(response is StatusRequest) return response;
  else return StatusRequest.success;
}