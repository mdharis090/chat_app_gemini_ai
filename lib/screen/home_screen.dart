import 'dart:html';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({Key? key}) : super(key: key);

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];
  ChatUser currentuser = ChatUser(id: "0", firstName: "user");
  ChatUser gemniuser = ChatUser(
      id: "1",
      firstName: "Gemini",
      profileImage:
          "data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIAJQA4AMBEQACEQEDEQH/xAAbAAACAwEBAQAAAAAAAAAAAAAAAQIDBAUGB//EAD4QAAIBAwMBBQQIBAUEAwAAAAECAwAEERIhMUEFEyJRYTJxgZEGFCNCobHB0VJTcvAVM2LS8SSSosIWNGP/xAAaAQEAAwEBAQAAAAAAAAAAAAAAAQIDBAUG/8QAOBEAAgECAwQKAgAFAwUAAAAAAAECAxESITEEQVFhEzJxgZGhscHR8CLhBSMzQvEUYnIkgpKi0v/aAAwDAQACEQMRAD8A+MHetjIFGTgc1IBlwcUAqAKAKAKAKgkYzUgVAFAPSetALFBZhUEklUk7CpKtliwkxux6EVdRbi2Ux52KipAGRVC9xUJCgHQgVQBjFSA2oBUAUAYoAoAqAPipAwTyKE2G+ARyTgE5GN6EETQCoBmgFzQkKAYoQA3oTYut7aWYF1UaFO7MwC/EmrwpymrrTwKSnGDs2a4rJJFMkaTzr1+rphQf6jz8q2hQTV7OXYvd/BlKu1ldLtfsiuR1hbR9QVG8ptRJ/Kqyag7dHZ87/osliV8fhYnYyvNeRI1vbhGbBAtkP5ipo1JSmlhVv+K+GUqxjGm2m79r+SVpM7ldUFrIPI2yfoBVqLcmrpf+K+CtWKvq1/3P5PV2vYE8tg7/AOHQFZArI0U2jI6/e2xXpf6aKTVraHiz2+nGql0j71f2PPdoWFssjBZXgYHBEw1KT6Mufy+NcNbZlHl9+7j1aVebSbV+z4fycq5tJbfeRRoPDqQVPxG1ck6coZvTy8TspzjPR5+fhqUEY6Vma2FUkBQgKAKAKAKAku4PhBz18qE2ERg4NCBUAUA8igJOxfLHGwA2AHG3T+zyd6IEaAVAOgChIqgEkVnYLGrMzbAAZzUpNuyDsldmtEt7R1FyO+kzvGp8Ke89T6cVulTp9fN8OHbxMW51F+GRG+78zmOWQuFxoxspXpgcAVStixWk7lqWDDiirHS7Pdp4YYQFKEGN2SYDQpOclT19a66DlKEY2y010XZxOaulCTm78dNX2mTtKNe+jWLLOAQ6JIZQhz0NYbQk2lH1vY2oN4bvLut5B2Xb3Ud/A3dToofOdJ2q2z06sZptMptE6bpyV0dbspe0FaPXbPIoxq7yEMPmRXfsTqJpVDi2mVBp2lbvsfTuzbns6LsxEeSBGUHIAIAJrsqRqSqXWh8ZtFLaHWckmfMvpAbR7l9BfVqI1A5Hw4rm2503qfY7Eqqir/fU5Fs3cvJKJT3SLup2DseB5efwBry6bUHKSeXq+H3mehNYko2z9FxKBDDdHEWIZzxHnwOfIE8H0NVtGp1cnw3Ps+GaXlDrZrjv7zM6FGKsCGBwQdiDWNrOz1Nbpq6I0AVBAVIHigFQDUlWDKcMDkHyoBuS7FmOWY5JPU0GhGgCgHQBQCNAS0743ziguDDj13oSKgJxQvKwWNSx8gKlRcnZENpK7OtBbKluEgmUSyv3YkwdzjdVPQevWu2FJYbRebdr8+C4e/Yck6jxXkskr293x7N3acjSQTjp1HFcNuB2XvqbIY/rdtlnVO4IAkf2Sp+77x0Fbxj0kP8Ajv5cO4ylLo56a7ufEgXhiGI1Ex6tJ7PwUc/GqNwjor9vx8k2nLV27Pn4RGS7nbSqO6DoI/D+VS603v8AYKnHW3uZ2ywDOdWT1rJ56l1loaIJCmGUkEdRtWkJ4XdGU431Oza9u3cVrKondh4dpDqHPrXoU9saizhnsNNzTwmK6u4LpszRd0+fbh9k+9T+hHurlnWjV62vH9HRTpSp9V3XP5+blV5GVt4xHh4F3LrwzHnPl5VSrFxilHNe/wB4m1KScni14ciqytRdK6IzNOFJWILnUB61SlS6VNR14fstUqdHZy048DRcxJqW0uJM3ajeQjAU/wAJPX31vOKypzf5cfZvf2mUJOzqQX48PdfBzZEaN2R1KsuxB6VyuLi7PU6E01daEaqB42qQAoBUA+Rt0oAFAI0A6ADQAcY9aADz50AyPBnAoCQwV9kaunNCWRXLNvhT5t0pcGwobSLuxj6xKuW//NT0955PpWz/AJasus/JfsyX8x3fVXm/0b4+0YriaFEBUhmePXgLGwQgAY6ZxvXVHaYzaisrXavonbLuuc0qEoRcnyvbV55s58UIjXvrk5QeFQpwXI8vTzNccYJJylp6/rmdUpXdo/4XzyKriYz6SdIUeyqjAQe6olNzeehMYKN0i/6mIoFklUuzeyinTgeZ/atVTwwUprN7jPpMcmo5GmXsx17O+vPAIk2KguTqBOOORWs9mkqHS4bLt4mcdqi63RKV+45hXnf51xnRcWSVK7Y88b0JRoht7iWJnjjYrkAngD48VeFOcl+KM5zhF2kymWN4jpcYz0qri45MvFqWgQzNC5ZMYIwVPBHkRSMnB/j+iXFSyZshMIjmkRHMUihZY1bDoMg7EjcZFbxwYZNaPVb+Ji8TlFN5rNPc93iZ7yT6zKGVNK6VRFO5wBgZ8zWVWeOXh5czSlHBHN8/HgTXN3DgnM0SnBPLp5e8flV1/Mi1vXmvlehDeCXJ+T+GZCDk1gakaEBQBQBQDoBUAUAyKABjrQASM0AwNzzQDG22Ac+dCTVZ6WYtMoMUC6iv8R6L8T+ta0km7vRfbGNW6Vo6v7ccrRXhL6+7nZiSj+yx9G6e4/Opk41Xe9n5EpOGVrrz+9hCO2Kyt9ZBRIxrfz9APU1CpNP81ZLUOomlh1ZGSXvpNRwNtIUcKOgFVnNzd2TGOFWX+TVbWoCCWVdjuqHr5E+n51vSo3WJmUqmdom21ia+uRCwJBOXY9E6/OuqnTdeph4+n7OarNUoYvt/0b/pNeQmzW1VlZtWfCc6cdDXR/Eq8OiVOL/Ryfw6jPpXUaPNhdZ0gDJ49a8U9jQgF0PkqCV6EbVGazJ1PQXVqIey7a5glljjkiEciatjkcke/mvVr0VChCcdLWfyebSqOdeVOaTad0c6eIS2wVI8NHuo/v8AvI9a5pRvDDHd9+9nM7Iyalib1OaF2z51xdhu2WQyNHKJFxkcgjY1eEnF4kRJKSszQ9mZPtIcC3IzqY4Ceh91X6K/5Ryj6cjNVMOUtfUgk8do2q2XXKDkTOOPcP3qFONN3hm+PwWlFzVp6PcQu41Eiyw+GKVdSjy81+BpVSxYo6PP72E05Nqz1RlxWRe4UJCgFigHQCoB4PlQXAA0Fyaxls+JRgZ3OKENkdOTtQXLGwE0jfrnrQi5AKdQ2oWvc6cVmZLCJVkiQtIGbWSCWOQg2B9a640b0kk0s8++9vc5ZVkqrbTeX+fYhL2XIkbSieF8avCmSfD7XTpVZbNKMb3WV9OWpaO0xcsNmtNeehTeSSJBBbMSQo1upP3iOPgMfjVKspJKm92v3sNKaTk5pa5L72lFuO8uIUY+FpFU+4kCqQWKcVzXqXm7Rb5HVTXcSuuwTAdyegJ2HpsAP+a7bOcnnlr98vrON2gr2OtZXEdhC0Rt8sTlpVbeT1OdxXfQmqCwuOfHj7nBXpyryTxd3AwSypP2qkkFvFGPak8GrIHJORXLOSntN4xXF+50xi4UHGUr8Nx1mufo/Ime5iPoIN/htXa6+wtZpeBwxpbfF6vxMJ/+OPlhrRjnw6XH6Vz2/hzeLTxOlf69Za+BJZLaW3MMSk2p2IOrb51vGdDoujj1eZVxqKeN9Yojt1tznWSmMxtjPvBHoPniuXoei7N337e3E6HUc813+xjvrQ92HRcEeJ1BB28/394NclelliXf9+8TelUzwv793HOHFcqNjTa5kD2/8z2D5P0+fFaw/L8OPr9yKTdvz4ehR3TkZ0Pp6nTxWWGXA0bV9S5UY2ksLoyun2ihhggHZvwx8q1SbpuL1WfsyjdpqS0eXwYt6wNBGhYMUJFQBQB0oC7TVsJliFgA1FiUSZSoBOB5b1BJWGwM6cnNCbFgBqUrlWyaRFtgMsdgPM1ZQxZFcVs2dGeeKK6mjPEdzFp220pkH9665VYxm1zj4LU5o05ShF8U/wD2zL7SSDuUZpEJkabSnXBPJ8hjNa03TwZvVyy5MpUU8TVtFHM4bTE3LSsA2WLYIyDXnyk5SxM9BR/GxOzj/wCttwcAGVN22xuNzU0f6ke1epWq/wCXLsZ2+yIEnuLjDkabdSrx4BX0r0tkpxnOSb0SzTODaqkoRjlq3qW9m2zX1qrJLbrgfaIYsMp92cfhV9lpyr07xkvD6vIz2ioqM7ST7b/Wa7i2j7N7FuXj1PO4CNIQM4J4HQCuitSjs9CTWbe/wOaFWW0bRFPRbjzKjk9AdtIzivCPZsTgYRTRtpDspDaTvn0q9N4ZJ6lZrEmnkdrtFNM4DFNxnwnbf1r2NovJp2POoP8AEssYGKuDjjUrE+zjg1elBuLuRUmln9ZUsQYFGIUNyP8ASdsfinyrDAnl9z/yjRzat90z9meewAzDy23HQV4uh6WowdLB0PBypPSrXazFlvOzbzhb2CJO8TLM4wfC6sudx5ivRp1F0kYq61firnFOH8qTee7wdjFFcCe4tI2ZyCpjd33J1/oM1zxqY5wXam9+ZvOGCMmu3wMBXCjVs2cEVx5rU3uQIGDQsiA3FCRYoB4oLgRgVITNYXIzitrHPcpdDWUkaRZVjB5qppuL4I1Zt9/0rSnBSeZnNtI2wpEToOxJ2Y1204U+rbvOaUpam/s601dqWkWAVMynzzg71tHZ8NRGFetajKXJnLuY3Rjq9o7tv161w1qTizshK6IWgKmZiSD3Db488L/7VnS1l2fr3LVJdXt/fsUqNKkY+NZmjYiBjfrRoLU9B9H5RBa9o3ROIlQIq55OM/qK9T+HtU6dSqzztv8AzqU6a11Mv0djuH7Wt4YT4nOlh6DnaufYpSjXjhNNvcFQlKW76jv9vSLGGslw5bBm66R0HoSa9fa6qa6Nd/Z8vceZsUHK1V933keWvIhDKe7IaNsmMk8jjPzBrxK1PA8tPX7me1TlijnrvNPZaxo8dxMDpSZQPdncn3Vts0YxaqS0TVjLaMTThHWzudq+QQQy3DLlRuSepr2doUYRdSW482i3OSgjF2NNLcjtORic9yMDp1rg2OpOt0knw+Tp2uKg6UVx+Dg967AB5X1AY2NeTjm1nI9Ky3IpY452qpZFkfRsbZ56VK4lXwN10rmK1lxlTGV252dv0Irep1Yy5e7MqeUpR4O/ikY8924fy8XyrK7i78DTN5E79VS8uAP5rfmamurVZLmyKLvTi+SKGzjJI36dazNUQB8J8Plv5UJI5/GhJMcb1BRibGKEovaTYAbVq55ZGKjmVs5NUcrmiSK1Us1RqS2XgGJiDyKsnhZR/ki2NsuSzadic4z8K0xZ3KNHV7DuinaFszeI94MZ+NdtCtmkcm10r0pdhC5uzIqj6pABjgKaipUcnexanSwvrPxM+tGimCwQqe6ydKkY+0SsLpqX4rT3RtZpxzevszngb49cVzI3eeZZ3I8K+yc8mr4blcTR0EZ0+j9x5S3YQfBQa6oNw2OUeMvZHM0p7XHlH3ZX2RLNZ3okgdRMUIDEEkZ6gday2ScoVLx4Gm0wjVpYZ6GuVz3hOGkYsSx9p3PUf1HqeBxXVJ2f2/8AnnolkYxjllkvL/Hm9WW3dgY+zJZZwouXZBGi8RLkALV62y4aDnPrZW5Z2t5mdPaL1lGHVV78+Yu07QWYtQoBhaLDDnccn54NNqpdEopaWz+fRjZqzq4m9b+v2xo7NuRiaC/YmCUd2ueEbHH4ir0KrSdOp1Xl2Ge00b2nS6yz7TJ9Hi8PaT20uxlQoV9RWP8AD24VnB70a7clKiqkdzRxDE0Z0OpU+RGK81xcXZnoJqSuhaSc6R8DUWbGIsQyJH3Wo93nVpz1xVkmlYh2eZuM6RWNupRGJDnDrnrgdfSunGo04prj6nPgcqknfgZnuUKEG3gGP9B+XNZSqK2cV4GkaTv1n4i7QGq9uCP5pqK6vVl2smh/Sj2IwvzWOhuhe6hYMZz5gZqAImgsGdqAtPPNDMMVIuMDGKAmzkqATxxUkWQKalMho12R7ueGYnCpIrH4HNdFLKSZlUzi1xRuithN2lPaFyERn8WMnC549cCuiKvNwZzynhpRnvdvMi1vGlzF3DO0d3E6qsihWzgjBwT1xvWagrq2jTLKbwvF/a1pmcqNckAD1rljC7OqUjX3aopDDIxzweK6OjSMsVzYjwSdhXNvJvJHOsqZ25AWtlKL2eUeDuYOMo7TGa0at53K+ybP6zdmOLDBU8TEYA9KpsdGVSbS0S1L7TWVOneQ+27dbWQJDIMgaZGGxJxwCOB6Dyqduh0TWB9v3hyGx1HUjea7DVZXsvaEVvbSau9jky5I2ZVGfnxXTs+0S2iMKUtU/JGFahGg5VI6NeZs7SljEcMLaTc6tYXHCgHUD7966drnC0Yb+HLeYbNCTbkur73MqhGhNqu+dcZPUkLrQ+/AIrmspRwd3ldfBq21LpHyfnZnOkdoJbW5RiHIDBwP4Tj9K5JtpxmjrilJShJfWrku2L8dpTpL3YjbAWo2mt08sVrFdlodBDBe5hGcZztnkda51kdDQM4chRso3FMQSLL+EgK+k6IkRH9Cct+pq1aLSXBJfJWk73XFv4Irbv8AW4YpAAxdQy+QOOfhUKm1VUHyLuUcDkilpe9kkkA9tmY/E5rNzu2+JOHCkuBS4zk1U0RAioLIlGAdRZsHGwwd6AgdqAWKAsTYUKyJirIoPpRggzdOtVLWGm/NCGXxyFQByPdW0Z2KONz0dje26TRXNxc3UEc6qzvA2MEDBztnkfjXfCccpt2ukeZWpzlFwjFNpvXnmY7jtRWhEcTXLaGGhZJMrseMYrOddaJvI3hszUm5JZ8Fn4lcluiXRdM91Jh06eFv2OR8DVlTWLtLKV4Weqy8CuTBZQRk0qW0JjkUTRxoo0yYJB1rg9MYx51yS/Fm8W3u7D0XZ9p9V7GaYTGGVwJNY2x5A17Oz0ej2W97N5nk1quPaVG10svk40w7y1laXlvGNXOrn/eK8+or023vz9/lHoQdppLs7vtma+wILhLWW8t1TJ8IMhyAByR7zWv8PpzjB1I+ZhttWnKapzeRDtGN4RB2k6M8k6sWU8KxBx+BHyptEJU3HaJav3X7JozjPFQWSXyKxuIpIpCMJNn7NXOMkpoG/wASTU0asJX3Ph3W/YrU5Jrhv8bv2F2vbxpDCbVmdIU7t20eE45IPB3qm0UkoJwd7ZE7NUblJTybz1zOQW0jTgGuDQ7d4NpAUDjG5FLgLZRJMA3sjds8BRuTUQjilZ/VqxJ4VdfWaxfILa7LxRO00ilVcEn8+lbqusE20s3vM+heOCTeXAc80cl9c3SBVCR7MudiRgZ9dz8qtOcZVZVFol56EQhJU403q3n6nK1bYHyriOq2YiSaEoQznfGDQkk6Y6ihCZWaEjzQFijahRkhUkATtS4KjzmoLklNCrLc8AadvIc1JU127CWB4XB+z+0XHOPvD8j8DXTB44uPDP5+TKawyUlvy+PjvJWaNKGVU1DGdZ2CepPA8t6mlduyV+YqSUVm/wBnSbumthBE5lniBYaV2Od2Vep8/nXQmrYYu7Xmcv5KeOSsn9Te7kcp5S3I561g53OhRsAHfShA2ksQB7ztVOvJIv1Vc7v0l7RVCLCEDCEGQ9Mfw16X8R2lJdDA83+HbPf+dJ66fJxO0bkTylYlxCjHQPMZJBPwNeftNbpJNLTP1PQoU8Ku9f8AB2J77/DexLa2QD6xNHlh/CD/AM13zrf6fZYwXWaOCFH/AFG0ym+qmOC+N59Hp4A2J4U8S/xqPL4bbVMa7r7JKK1S8iZUFS2uM7ZP1POY8WODnbyxXj5nq3PVfR68huezh2bJjWgOP9Sn09K9zYKsKlLonqkeLt1GdOt060PNXsLwTSxOv+W+kt5+X4V41Wm6UnDhketTmqkVJbylW09cZrK5pa5rRUSB0kcJNKAdxsF5wccZ2PyreKUYWbs36fsybcpJpZIxzRyQviRSuePI+oPWsZQlF2ZtGSksiyb7C2jiBIeT7R+n9I/M/EVpL8IKO95+y+fArD8pt7ll8mUAaTt0FZGgv0oCRBVzgn4VBJF+d6AWKAYC/eOKAnnehQe+FbHhPBoBHBJGceRqSUQPNQSTWhUkKEE7eUwSLIuNSnIB61aE3B4luIlFSWF7zdetI4V4vDbMNUaKNlPkfUZxmumq22muq9DGmkrp6k4bG5kjjnikjXJJUmUBhp529OatCjUklKNvHh8FJ1oRbg19fyRuodXeSqUVlUO6LuDn7y+nX0qKsH1t+r+V9yLU5LKPd+mT7GiR7hbi5ljSOE6/Ed2I6CtNkhGU1ObyRTaZNQdOCzZguJ2uJ3mb2pGLH41yzqupJzerN4U1CKitxv7MsYbho5bqeKOENupcZb4dBXTstCNRp1JJLzMNorygmqcW2Ze1bg3HaE8moFS2FA4AGwx8Kw2qrjrSf3I12eGClFfcx9kz/Vu0IJCQFLBWzxg7Gp2Wp0daLI2in0lJxNXavZ6W8zy200MkXIVXGV9MVvteyqEnKm01wM9m2hzglUTTOXHM8Th1Yq6nKkdK4YylFqS3HXKKas9Dq9oN/iVrHfp3QmVSkyasHb7wFd+0f9RTVZarX5RyUF0M3Remq+DnwqkSLNN7J3jQj2z5/wBIrkhFRWOXdz7eR0ybbcY9/L9lTu0hMjsSXOSw3rNtt3ZdRtkjTZuAGMozbINTow2J8h5E1tRbV79VZ/eZlUWat1jJPKZJGeQZZnBO9ZTk5ScnvNoxwrCiv7oqpIqEiqASLZVRpA053HJ99AlzImgFQEt8mhFgLZwPKgsFCRbk+poQWgAbE7+VCrGcjipZAZ29fOhBotplVWhn3if72M6W/iH97itYTS/CWj8nxKyg28UdV58jerrbLDDM/sLNkgbeJcKR5gmulTjTtGX+7zWRg4Sm5SX+3yeZRMAY47qO5RWjhRAoPiJGxGP7zWc7SSmpaJduWpaCabg46tvxIGJbrLR4ikC5YMcKf9p9OPdVFBVc1k/L9GmJ08nmvMyzRvC2mQFTzv1rGUZQdpKxdPFmsyHT4elR2lg1ALjHnvmiAg+OlLiwAjfYEjpiq2XAtmEaNI+hFLMd9KirxTk7LUiTUVd6F7xpasO/VZZf5f3V/qPX3CtHCNN/lm/uv3vKqUqi/HJfdPvcbLO6SRG+sSW+pzg98mQwHGT90Dpit6VVSTxtZ8fTkuBjVpyi1gTy4P7fmO503cYWCWFiW1MwiCEAZ3bfYeWOamphqxtBq75W04+xFO9N3mnlzvrw9+Bz7mZCFigz3S7gkYLHzNc05p2jHqrz5/dx0Qi85S1fkUq+ncY+VZlnmIEk4wPlQDxyVztuSBnFARG58R3PU1BIHI2NALmgFQD6YoQI0JCgJAkYI5FCGXd4WHiJJxgEk7UKkRud6ANvOpIJZOAM7CgLoZk7sQzgtFvjA8SHzH7VrGosOGavH0KSi74o6+oXELRqHGl4yMLImwP7H0NVnTcVfVbnuLU5qTto+AXTdyiwA5kyHlPw2X3D8zUz/FdG+/2XcIfk8Xh8lcd06RFfaUHOlxqGPQdPftVYzmlbVc8/vbkWlCLd9Pvn5m28toobeGeVAqynYwSE/gwrpqUYQgpyWvB/JhTqTnNwT04r4Zlit4J5VjjuJQWOBqhH+6so04Tkopvw/ZpKc4K7Xn+ioJbbn6xKw/0wgZ/8qo401rJ+H7L3nuj5/o3JZo0kUNtbyTSOqvl3woB4Ow4866I0U2owV3r3M53WaTlOVlnu4dpmvzPBIYG0RqQG0xbKwPXzPxrGtjg8DyXI1pKEljWb5/fQi3/UWyvzJCNL+qdD8OD7xUP8oX3r0/W/uLr8J4ePr+yMFu0mqTwpCPad+B+59KiNPEr6LiTOajlq+CJXM4EYhgBWE7nPMh8z+1TOaw4I6evb8ERj+WKWvp2fJl26DFZFwoCQOHzUgASq7bZ5qATV1KgPGCFGMrsx9560FuBV0H40JYuKEDoAoQFCQoBgUBJaFGTPhJx060BHNALV0oLBq3oTYtt7mSBsxNjPKkZDe8HmtITcHdFZQU9S2T6tckuZO4lJydZLIT7+R+NXapzzTs/FfKKrHDLVefwy2zSSxY3Lxu2kfZ934kcnzYdONq0oxlRfSNaaWzT7+HIpVcaq6NO19b6+HEzXd29zO7s5AY50ashTjFYVKjqSbNoU1Tiktw+z/wD7sXIOsAVbZ/6sStb+lIzBvswM4ArBdVG286Ed7js5bdG03Ak0hwcEJnI395NdUa7VLAspJ68tfU5+h/mubzjbTnp6D7SgkuLtplAKlV7yZjpQtjfBPSrV6cp1MXi91+1kUpxhBRfct9u4rR4LM5V/rEhBGBtHg/ifwrNOFLO935fsvJTqZNWXn+jNPcST/wCYdlHhUDCqPICspzc+totDSMVDqlXNVJCgCgA/lQBmgDPpQkmzPKyll3VQNlxsNun50ItbQjnO9AKhAUAUAUAUAwcUBINnahFhE4oTYQ4oSKgCgA0BNJHiOYpGQ9ShxUxlKGcXYhxUlaSuXm9lYYlEUuP5kQNadPL+6z7inQw1V12Mcd4EmWUWltrU5HtgZ/7qKqk7qC8/kOldWc3bu+CsXCLutnbfHWfwLVHSJf2Lz/8Aotgb/vfl8E1vpU/yxHF593Gq1PTTWll2Ir0MHrn2szySvK2qR3c9C5zis5Nyd5O5dRUckrEc1BIMMHNAAoBUAxQBQDBGkjC7nOeooBDJ4zQEgcbUIFQCJoCWPss9c4oCNAFAMUAqAKAKAKEjFAKgA0ACgDNABoBUAxwaEioQHlQDJz8KAKAOuKATUA6AKAlGMuvqcUIE2zEetAKgCpB//9k=");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/h.jfif"), fit: BoxFit.cover)),
        child: _bulidUi(),
      ),
    );
  }

  Widget _bulidUi() {
    return DashChat(
        inputOptions: InputOptions(trailing: [
          IconButton(
              onPressed: () async {
                ImagePicker picker = ImagePicker();
                XFile? file =
                    await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  ChatMessage chatMessage = ChatMessage(
                      user: currentuser,
                      createdAt: DateTime.now(),
                      text: "describe the picture ",
                      medias: [
                        ChatMedia(
                            url: file.path, fileName: "", type: MediaType.image)
                      ]);
                  _sendMessage(chatMessage);
                }
              },
              icon: Icon(Icons.image))
        ]),
        currentUser: currentuser,
        onSend: _sendMessage,
        messages: messages);
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          //File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }
      // Start listening to the stream
      gemini.streamGenerateContent(question).listen((event) {
        ChatMessage? lastmessage = messages.firstOrNull;

        // Check if the last message is from gemniuser
        if (lastmessage != null && lastmessage.user == gemniuser) {
          lastmessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous${current.text}") ??
              "";
          lastmessage.text += response;
          setState(() {
            messages = [lastmessage!, ...messages];
          });
        } else {
          // Concatenate parts of the response if event.content is not null
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous${current.text}") ??
              "";

          // Create a new ChatMessage object with the response
          ChatMessage message = ChatMessage(
              user: gemniuser, createdAt: DateTime.now(), text: response);
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
