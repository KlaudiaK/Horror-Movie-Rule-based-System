# Horror Movie Rule-based System

This system will find the horror movie from your worst nightmare  :upside_down_face:  :ghost:
- [Klaudia Kowalska](https://github.com/KlaudiaK)
- [Michał Zieliński](https://github.com/MichalxPZ)

## Prerequisites
* Java 11
* Maven 3.8.1 (only to build jar)
* CLIPSJNI.jar (only to build jar)
* CLIPS and [CLIPSJNI](https://github.com/gomezgoiri/CLIPSJNI/blob/master/library-src/README.md) installed on your computer as well ass graphic libraries according to your os.

## Build
* `git clone https://github.com/KlaudiaK/Horror-Movie-Rule-based-System`
* `mvn clean install`
* `mvn exec:java`

## Run
* `java -jar HorrorMovie-0.4-jar-with-dependencies.jar` (make sure that rules descibed in horrormovie.clp file are in the same direction as your jar :))
