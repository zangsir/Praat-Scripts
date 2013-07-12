writeInfo ()


#please load the sound into the object window first and select them
nos=numberOfSelected ("Sound")

for w from 1 to nos
    soundOri'w' = selected ("Sound", w);
    printline soundOri'w'
endfor

#read in the file that contains all the names of the targeted pitch tracks
pitchNames=Read Strings from raw text file... ~/Desktop/mbidsel_test.txt
numOfPitch=Get number of strings

if nos!=numOfPitch
exit ERROR!PLEASE MAKE SURE YOU SELECTED THE SAME NUMBER OF SOUND AND PITCH TRACK FILES (SPECIFIED IN THE MBID FILE).
endif

#@@@@@@@@@@@@@@@@@@@@big loop@@@@@@@@@@@@@@@@
for u from 1 to numOfPitch
select soundOri'u'
noc=Get number of channels
sampling_frequency = Get sampling frequency


#Get the MBID of the track from the MBID text file
select pitchNames
name$=Get string... u
firstc=index(name$,":")
name$=left$(name$,firstc-1)
shortname$=left$(name$,6)

#proceed to the pitch track file. each pitch tracks does not contain a header, we need to add it in (if we haven't), so first we read it in as a raw string file
pitchTrack=do("Read Strings from raw text file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt")
firstline$=Get string... 1
firstword$=left$(firstline$,4)

if firstword$!="time"
do("Insert string...", 1, "time"+tab$+"pitch"+tab$+"confidence")
do("Save as raw text file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt")
endif

#then we read in the pitch track file as a table
table=do ("Read Table from tab-separated file...", "/Volumes/PENDRIVE/jingju annotation/pitch_data/"+name$+".txt") 





u$=string$(u)


#######original part starts
select table
nor=Get number of rows
j=1

count=1
################
repeat
  
  start=0
  end=0
  call FindStEnd count
  call ExtractSound start end

until count=nor-1
###################
printline starting concatenating a segment
select sound1
for i from 2 to j-1
  plus sound'i'
endfor


newSound=Concatenate
select newSound
newSound=Convert to mono

do("Save as WAV file...", "~/Desktop/newSoundOrig_" + u$ + "_" + shortname$ + ".wav")




###################


procedure FindStEnd cont
#i is reset to 1 everytime this procedure is called
i=cont

if i<nor-1


#this loop ends when a start and an end are found for the segment, or when the pitch track exhausts
  repeat
    select table
    
    pitch=Get value... i pitch
    nextPitch=Get value... i+1 pitch


      if ((pitch=0) and (nextPitch>0))
       start=Get value... i+1 time
      endif

      if (pitch>0) and (nextPitch=0)
       end=Get value... i time
      endif

      i+=1
      count+=1

  until (((end>0) and (start>0)) or (count=nor-1))

printline found start and end of segment 'count', start 'start', end 'end'



endif
endproc





procedure ExtractSound start end
if ((start>0) and (end>0))
     select soundOri'u'
     sound'j'=Extract part... start end rectangular 1 no

     mySilence = Create Sound from formula... silence noc 0 0.2 sampling_frequency 0
     select sound'j'
     plus mySilence
     sound'j'=Concatenate

 

     j+=1
endif
endproc

endfor
#@@@@@@@@@big loop ends@@@@@@@@@@@@@@@





