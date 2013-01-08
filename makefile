
#  rightsdraw
#  Version: 2.0.1
#  Authors: L. Boch
#
#  Copyright (C) 2010-2012 RAI - Radiotelevisione Italiana <cr_segreteria@rai.it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

ALL: build

VERSION = `date +'%FT%H%M%S'`

clean:
	rm -f logs/*
	rm -f logs/.tmp*
	rm -rf build_root
	rm -f www/html/query/*
	rm -f www/html/mco/*
	rm -f users/*/repo/*/.tmp/*
	rm -f users/default/repo/*/.[a-Z0-9]*
	
build:	clean
	rm -rf build_root
	mkdir -p build_root/rightsdraw2/users
	mkdir -p build_root/rightsdraw2/logs
	rsync -av configure build_root/rightsdraw2/	
	rsync -av makefile build_root/rightsdraw2/	
	rsync -av LICENSE build_root/rightsdraw2/	
	rsync -av license.h build_root/rightsdraw2/	
	rsync -av newinstance.owl build_root/rightsdraw2/	
	rsync -av setkpr build_root/rightsdraw2/	
	rsync -avC --exclude *.bak bin/ build_root/rightsdraw2/bin/	
	rsync -avC --exclude *.bak xsl/ build_root/rightsdraw2/xsl/	
	rsync -avC --exclude *.bak share/ build_root/rightsdraw2/share/	
	rsync -avC --exclude *.bak  www/ build_root/rightsdraw2/www/	
	rsync -avC --exclude *.bak users/default/ build_root/rightsdraw2/users/default
	rm -f build_root/rightsdraw2/users/default/repo/*/*
	rm -f build_root/rightsdraw2/www/html/kpr/*/.pictures/*
	rm -f build_root/rightsdraw2/users/default/repo/*/.aipids/*
	rm -f build_root/rightsdraw2/www/html/js/CalendarPopup.js
	cd build_root/rightsdraw2/ ; make clean ; cd .. ; tar -cvzf ../rightsdraw2.$(VERSION).tar.gz --exclude-vcs .
