#read in the file that contains all the names of the targeted pitch tracks
pitchNames=Read Strings from raw text file... ~/Desktop/mbidsel_test.txt
numOfPitch=Get number of strings

#big loop@@@@@@@@@@@@@@@@
for u from 1 to numOfPitch
select pitchNames
name$=Get string... u
firstc=index(name$,":")
name$=left$(name$,firstc-1)
shortname$=left$(name$,6)

#each pitch tracks does not contain a header, we need to add it in, so first we read it in as a raw string file
pitchTrack=do("Read Strings from raw text file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt")
firstline$=Get string... 1
firstword$=left$(firstline$,4)

if firstword$!="time"
do("Insert string...", 1, "time"+tab$+"pitch"+tab$+"confidence")
do("Save as raw text file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt")
endif

#then we read in the pitch track file as a table
table=do ("Read Table from tab-separated file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt") 
select table
nor=Get number of rows
j=1
p1=0
sub=1



#################
for i from 1 to nor
if j<9000
#printline i='i'
select table
if i<nor
 pitch=Get value... i pitch
 start=Get value... i time
 end=Get value... i+1 time
 nextPitch=Get value... i+1 pitch

else
 pitch=Get value... i pitch
 start=Get value... i time
 end=start+0.001
 nextPitch=1000
endif

if ((pitch >0) and (nextPitch>0))

  f1 = pitch
  # f2 = nextPitch
  t1 = start
  t2 = end
 # printline start is 'start', end is 'end'
  #printline t1 is 't1', t2 is 't2'
  dur=t2-t1
  #a = (f2 - f1) / (t2 -t1)
  #b = f1 - a * t1
 # printline duration is 'dur'
  sound'j'=do ("Create Sound from formula..." , "sweep" , 1, 0 , dur , 44100,"0.5*sin(2*pi*f1*x +p1)")
  p1 = (2*pi*f1*dur + p1) mod (2*pi)
  j+=1
endif

  if ((pitch>0)and(nextPitch=0))
     normalize=0.2-0.003
     mySilence = Create Sound from formula... silence 1 0 normalize 44100 0
     k=j-1
     select sound'k'
     plus mySilence
     sound'j'=Concatenate
     j+=1
     select mySilence
     Remove
  endif
#printline j='j' 

#j=9000
else
  printline concatenating newSound'sub'...
  select sound1
  for q from 2 to j-1
  plus sound'q'
  endfor

  newSound'sub'=Concatenate
  select newSound'sub'
u$=string$(u)
sub$=string$(sub)
  do("Save as WAV file...", "~/Desktop/newSound_"+ u$ + "_" + sub$ +".wav")
  sub+=1
  
  printline dumping objects...
  for q from 1 to j-1
   select sound'q'
   Remove
  endfor

j=1
endif

endfor

#concatenate the very last sound, when j<9000 but there is still a number of frame for j>1
if j>1
  printline concatenating the last sound segment...
  select sound1
  for q from 2 to j-1
  plus sound'q'
  endfor

  newSound'sub'=Concatenate
  select newSound'sub'
u$=string$(u)
sub$=string$(sub)
  do("Save as WAV file...", "~/Desktop/newSound_"+ u$ + "_" + sub$ +".wav")
  sub+=1

  for q from 1 to j-1
   select sound'q'
   Remove
  endfor
endif
#####################



select newSound1
for y from 2 to sub-1
  plus newSound'y'
endfor

newSound=Concatenate
select newSound
u$=string$(u)
do("Save as WAV file...", "~/Desktop/newSound_"+ u$ + "_" + shortname$ +".wav")
endfor
#@@@@@@@@@@@@@@@@@
