# sprucedev.github.io
The spruce.sh website.

## To dev locally

    cd _harp
    npm run dev

## To compile - do this before checking in.

	# Unfortunately this is necessary because harp will delete all files in a
	# directory before compiling, meaning if we point it at the root dir it
	# will delete our README and our CNAME file. 
	cd _harp
    harp compile && mv www/* ../
