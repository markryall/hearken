# Hearken

This is a command line shell for queuing music tracks to be played
by [vlcraptor](https://github.com/markryall/vlcraptor).

It also extracts id3 tags from audio files for faster search.

This may may be platform independent but at this stage has only been used on mac os x

# Usage

Here you sit expectantly in front of a computer at the command line.

## Install

    gem install hearken

## Dependencies

Tags are currently extracted using ffmpeg.  On mac os x, this can be installed easily using brew:

    brew install ffmpeg

## Indexing tracks

    hearken_index DIRECTORY

Will create a track index at ~/.hearken/music.

Note that this will take a long time first time you run it if you have a large collection of music.  Subsequent
runs will only query tags for new or modified files so will be very fast.

The index can be regenerated while the console is running and reloaded using the 'reload' command.

## Console

    hearken

This enters an interactive prompt where you can search and enqueue tracks.

The queue will be persisted to ~/.hearken/queue

## Commands

    ?

will list all commands

    ? <command>

will describe the use and purpose of a particular command

## Main commands

    search iver bon

Searches for tracks with 'bon' and 'iver' in the track, artist or album name (this is case insensitive).

Results will be displayed and the ids will be added to the clipboard (for convenient pasting to the '+' command).

    enqueue abc-f 123 456

Enqueues tracks with ids abc, abd, abe, abf, 123 and 456
