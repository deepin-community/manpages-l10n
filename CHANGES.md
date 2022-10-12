# Changelog for manpages-l10n

## Version 4.11.0
*Tue Sep 14 20:57:20 CET 2021*

* Enable Hungarian translation
* Updated and added many translations

## Version 4.10.0
*Mon Jun 13 18:49:01 CET 2021*

* Enable Czech and Danish translations
* Hungarian is still disabled; still not completely imported
* Updated and added many translations

## Version 4.9.3
*Tue Mar  09 20:22:17 CET 2021*

* Final release for Debian Bullseye
* Updated many translations

## Version 4.9.2
*Wed Feb  10 14:40:36 CET 2021*

* Remove man pages of procps/procps-ng, now maintained upstream;
  only Debian Buster keeps the files for possible backports
* Updated and added many translations

## Version 4.9.1
*Sat Feb  06 21:38:01 CET 2021*

* Updated and added many translations

# Changelog for manpages-l10n

## Version 4.9.0pre1
*Sat Jan  23 21:39:01 CET 2021*

* Updated and added many translations
* Enable Italian, Spanish and Macedonian
* Still skip Czech, it's a very early state

## Version 4.2.0
*Thu Oct  15 19:13:01 CEST 2020*

* Updated and added many translations
* Still skip Italian and Spanish, will be included in the next 
  or any future release

## Version 4.1.0
*Wed Jul  1 12:26:57 CEST 2020*

* Prepare inclusion of two new languages: Spanish and Italian.
  Both languages are in very early beginning stages, so they
  are not installed yet.
* Add support for two more distributions: Fedora Rawhide and
  Opensuse Tumbleweed. The manpages-l10n project now supports
  six different distributions!
* Updated many translations

## Version 4.0.0
*Mon Mar  2 22:09:38 CET 2020*

* Rename project to manpages-l10n
* Switch to semantic versioning
* Include new languages: French, Dutch, Polish, Brazilian Portuguese,
  and Romanian. Thanks to all translators involved in this project!
* Increase version to 4.0.0, so that distributions should be able
  to prepare packages for all languages with the same version number
* Updated many translations

## Version 2.16

*Sun Nov 17 14:02:06 CET 2019*

* Prepare inclusion of French and Dutch manpages. Both languages
  are not generated yet, only the infrastructure is ready. The next
  release will include translated manpages for both languages.
  This release is mainly to update the German manpages before
  the distribution packages need to adapt to the new languages.
* Updated many translations

## Version 2.15

*Sat Aug 31 16:20:19 CEST 2019*

* Updated many translations

## Version 2.14

*Tue Jul  9 11:42:18 CEST 2019*

* Updated many translations

## Version 2.13

*Sun May 19 13:41:23 CEST 2019*

* Updated many translations

## Version 2.12

*Fri Mar  1 18:33:40 CET 2019*

* Updated many translations

## Version 2.11

*Wed Feb  6 21:16:40 CET 2019*

* Updated many translations

## Version 2.10

*Sun Jan 13 00:15:11 CET 2019*

* Updated many translations

## Version 2.9

*Fri Oct 19 22:44:27 CEST 2018*

* Updated many translations

## Version 2.8

*Tue Sep 11 20:22:54 CEST 2018*

* Updated many translations

## Version 2.7

*Sat Aug 18 23:02:30 CEST 2018*

* Updated many translations

## Version 2.6

*Thu May 24 17:09:16 CEST 2018*

* Updated many translations

## Version 2.5

*Thu Apr 19 21:40:58 CEST 2018*

* Updated many translations

## Version 2.4

*Sat Feb 24 15:29:34 CET 2018*

* Updated many translations

## Version 2.3

*Wed Dec 13 00:20:25 CET 2017*

* Fix wrong translation in find.1, spotted by Sven Bartscher.
  Thanks! Closes: [#883077](https://bugs.debian.org/883077)
* Fix in signal.7, reported by Nicolai Voget. Thanks!
* Updated many translations

## Version 2.2

*Sun Oct 22 13:14:03 CEST 2017*

* Updated many translations

## Version 2.1

*Thu Sep 28 15:44:19 CEST 2017*

* Fix typo in find.1, spotted by Sven Bartscher <kritzefitz@debian.org>.
  Thanks! Closes: [#877060](https://bugs.debian.org/877060)
* Updated many translations

## Version 2.0

*Sat Aug 26 14:32:40 CEST 2017*

* The package has been restructured to include the original manpages.
  During the build of the package, external manpages are no longer
  needed.
* As a result of this change, the already deprecated configure
  option *--enable-deprecated-download* has now been removed
  completely.
* There is now a framework in place, which should allow to support
  translations for different distributions. Some manpages differ
  between distributions, the package can now cope with that and
  still provide complete translations. This enables custom
  packages for e.g. Debian stable, Ubuntu, Gentoo, openSUSE etc.
  Currently, only Debian unstable and Debian stretch are supported.
  In order to build translations for Debian stretch, use the
  new configure option *--enable-distribution=debian-stretch*.
* The documentation has been mostly converted to markdown.
* Updated many translations

## Version 1.22

*Mon Mar 13 16:55:49 CET 2017*

* Updated many translations

## Version 1.21

*Sun Jan 22 22:16:24 CET 2017*

* Updated translations

## Version 1.20

*Sun Jan 22 21:57:18 CET 2017*

* Updated many translations

## Version 1.19

*Sat Jan 21 12:15:48 CET 2017*

* Updated many translations

## Version 1.18

*Sun Dec 18 13:11:21 CET 2016*

* Updated many translations

## Version 1.17

*Mon Nov 21 13:07:25 CET 2016*

* Deprecate configure option *--enable-download*.
  This option will be removed in the future. If this option is really
  needed for now, the new option *--enable-deprecated-download* will
  behave just the same but serves as a reminder to change the
  build process.
* Include bzip2 compressed manpages in the search for the original.
  Also reorder the compression methods to search for. The order
  is now gzip, bzip2, xz, uncompressed.
* Updated many translations

## Version 1.16

*Tue Sep 27 18:06:30 CEST 2016*

* Updated many translations

## Version 1.15

*Sat Aug 27 08:13:17 CEST 2016*

* Updated many translations

## Version 1.14

*Fri Aug 5 22:21:51 CEST 2016*

* New translations: iso_8859-10.7, iso_8859-11.7, iso_8859-13.7,
  iso_8859-14.7, iso_8859-16.7, iso_8859-9.7
* Updated many translations

## Version 1.13

*Thu Jun 9 14:40:27 CEST 2016*

* Updated many translations
* Removed translations: sk98lin.4


## Version 1.12

*Mon Apr 11 15:51:21 CEST 2016*

* Make build reproducible by telling grep that all files
  are text, not binary. Thanks to Reiner Herrmann for the
  bug report and patch. Closes: [#815192](https://bugs.debian.org/815192)
* Updated many translations

## Version 1.11

*Tue Feb 16 20:12:05 CET 2016*

* New translations: zramctl.8
* Updated many translations
* Removed translations: LDP.7, undocumented.7

## Version 1.10

*Sun Jan 3 17:08:16 CET 2016*

* Updated many translations

## Version 1.9

*Sun Jun 28 15:16:29 CEST 2015*

* New translations:
  bzdiff.1, bzgrep.1, bzip2.1, bzmore.1, cal.ul.1, ddate.1, exif.1,
  gzexe.1, lzmainfo.1, repoclosure.1, repodiff.1, repo-graph.1,
  repomanage.1, repoquery.1, repo-rss.1, reposync.1, repotrack.1,
  xzdiff.1, xzgrep.1, xzless.1, xzmore.1, yum-builddep.1,
  yum-config-manager.1, yumdownloader.1, zdiff.1, zforce.1, zless.1,
  zmore.1, znew.1, applydeltarpm.8, combinedeltarpm.8,
  makedeltarpm.8, resizepart.8, rpm2cpio.8, systemd-activate.8,
  systemd-ask-password-console.service.8,
  systemd-backlight@.service.8, systemd-binfmt.service.8,
  systemd-cryptsetup@.service.8, systemd-fstab-generator.8,
  systemd-halt.service.8, systemd-hostnamed.service.8,
  systemd-initctl.service.8, systemd-journald.service.8,
  systemd-machined.service.8, systemd-modules-load.service.8,
  systemd-networkd.service.8, systemd-networkd-wait-online.service.8,
  systemd-quotacheck.service.8, systemd-remount-fs.service.8,
  systemd-resolved.8, systemd-shutdownd.service.8,
  systemd-sysctl.service.8, systemd-system-update-generator.8,
  systemd-sysusers.8, systemd-timedated.service.8,
  systemd-timesyncd.service.8, systemd-tmpfiles.8,
  systemd-update-utmp.service.8, systemd-user-sessions.service.8,
  yum-complete-transaction.8, yumdb.8
* Updated many translations

## Version 1.8

*Fri Oct 24 21:59:18 CEST 2014*

* New translations:
  cpio.1, flock.1, mt-gnu.1, nsenter.1, prlimit.1, runuser.1,
  utmpdump.1, mq_getsetattr.2, terminal-colors.d.5, blkdiscard.8,
  chcpu.8, fsck.cramfs.8, lslocks.8, mkfs.cramfs.8, readprofile.8,
  wdctl.8
* Updated many translations
* Removed translations: chkdupexe.1, ddate.1, readprofile.1, cytune.8,
  getty.8

## Version 1.7

*Mon Jul 14 12:28:03 CEST 2014*

* New translation: pivot_root.2
* Updated many translations
* Removed translation: clock.8

## Version 1.6

*Tue Mar  4 14:55:29 CET 2014*

* Updated many translations

## Version 1.5

*Tue Feb 25 13:47:09 CET 2014*

* New translations:
  chkdupexe.1, chrt.1, csv2rec.1, ddate.1, dmesg.1, fallocate.1,
  getopt.1, ionice.1, ipcmk.1, ipcrm.1, ipcs.1, line.1, lscpu.1,
  mcookie.1, mdb2rec.1, more.1, namei.1, ncal.1, pg.1, readprofile.1,
  rec2csv.1, recdel.1, recfix.1, recfmt.1, recinf.1, recins.1,
  recsel.1, recset.1, rename.ul.1, rev.1, setsid.1, setterm.1,
  tailf.1, taskset.1, unshare.1, whereis.1, hwclock.5, addpart.8,
  agetty.8, blkid.8, blockdev.8, cfdisk.8, clock.8, ctrlaltdel.8,
  cytune.8, delpart.8, fdformat.8, findfs.8, fsck.8, fsck.minix.8,
  fsfreeze.8, fstrim.8, getty.8, hwclock.8, isosize.8, ldattach.8,
  lsblk.8, mkfs.8, mkfs.bfs.8, mkfs.minix.8, mkswap.8, parted.8,
  partprobe.8, partx.8, pivot_root.8, raw.8, rtcwake.8, setarch.8,
  sfdisk.8, swaplabel.8, switch_root.8, tunelp.8, wipefs.8
* Updated many translations

## Version 1.4

*Sun Dec 15 19:16:36 CET 2013*

* New translations: ogg123.1, oggdec.1, oggenc.1, ogginfo.1,
  vcut.1, vorbiscomment.1, vorbistagedit.1
* Updated many translations

## Version 1.3

*Sun Aug 18 15:09:58 CEST 2013*

* Renamed translation: getdtablesize.2 -> getdtablesize.3
* Updated many translations

## Version 1.2

*Sun Oct 28 12:50:50 CET 2012*

* During ./configure, check that po4a is available on the system.
* New translations: charmap.5, hosts.equiv.5, networks.5
* Updated many translations

## Version 1.1

*Fri Jun 29 14:11:32 CEST 2012*

* Instead of downloading the original manpages during building
  of the package, the software now uses the locally installed
  manpages on the system. To enable the previous behaviour,
  there is now an option *--enable-download* for the configure
  script. Thanks to Jeremy Bicha <jbicha@ubuntu.com> for the
  bug report. This closes Debian bug
  [#679122](https://bugs.debian.org/679122).
* Updated many translations

## Version 1.0

*Fri Jun  8 11:58:02 CEST 2012*

* Converted package to use autotools for setup and installation
* Removed generated translations from tarball, instead download
  the original manpages and generate the translations before
  installation
* Because of the above, the package now needs wget and po4a
  during installation
* New translation: iso_8859-8.7
* Updated many translations
* Removed translations which are severely out of date:
  groff.1, less.1, access.2, capget.2, connect.2, execve.2, fcntl.2,
  flock.2, fork.2, lseek.2, mknod.2, mlock.2, mmap.2, mremap.2,
  open.2, pipe.2, ptrace.2, read.2, readdir.2, rename.2, select.2,
  setpgid.2, setreuid.2, setuid.2, sigaction.2, signal.2, stat.2,
  statfs.2, times.2, truncate.2, unlink.2, exec.3, getdate.3,
  gethostbyname.3, getmntent.3, getopt.3, glob.3, hsearch.3,
  printf.3, readdir.3, strftime.3, syslog.3, tzset.3, wprintf.3,
  console.4, nfs.5

## Version 0.13

*Tue May 15 14:26:17 CEST 2012*

* New manpages:
  chown.2, getdtablesize.2, mkdir.2, setgid.2, shutdown.2,
  addseverity.3, atan.3, cacosh.3, carg.3, ceil.3, clearenv.3, erf.3,
  errno.3, ferror.3, getgrent.3, getgrnam.3, getnetent.3, getpass.3,
  gets.3, getw.3, hypot.3, isalpha.3, j0.3, malloc.3, memchr.3,
  psignal.3, random.3, scandir.3, setbuf.3, sinh.3, strerror.3,
  strtod.3, tan.3, rtc.4, proc.5, capabilities.7, iso_8859-15.7,
  iso_8859-2.7, iso_8859-3.7, iso_8859-4.7, iso_8859-5.7,
  iso_8859-6.7, iso_8859-7.7, libc.7, math_error.7, shm_overview.7,
  termio.7, undocumented.7, units.7, x25.7, fdisk.8, lilo.8,
  mkrescue.8
* Updated many translations

## Version 0.12

*Mon Feb 27 22:52:19 CET 2012*

* New manpages:
  chmod.2, getsockname.2, idle.2, nice.2, stime.2, asin.3, asinh.3,
  cbrt.3, copysign.3, cos.3, cosh.3, daemon.3, div.3, fcloseall.3,
  ffs.3, floor.3, gcvt.3, getusershell.3, initgroups.3, puts.3,
  raise.3, sigpause.3, strcat.3, strfry.3, toupper.3, pts.4, acct.5,
  utmp.5
* Updated many translations

## Version 0.11

*Thu Jan  5 22:34:51 CET 2012*

* New manpages: tar.1, getpeername.2, getresuid.2, bstring.3, fstab.5
* Updated many translations

## Version 0.10

*Fri Dec 16 22:44:36 CET 2011*

* New manpages: grep.1, acosh.3, fgetpwent.3, strdup.3
* Updated many translations

## Version 0.9

*Wed Oct 12 21:43:26 CEST 2011*

* Updated upstream manpages:
  manpages 3.32-0.1, manpages-dev 3.32-0.1, util-linux 2.19.1-5
* Updated many translations
* New manpages:
  binkdlogstat.8, ttyS.4, cpuid.4, dsp56k.4, mouse.4, msr.4, random.4,
  wavelan.4, man-pages.7, operator.7, initrd.4, group.5, resolv.conf.5
* Removed manpages:
  resolver.5 (linked from resolv.conf.5),
  write.1, ttys.4, rdev.8 (removed upstream),
  ar.1, ps.1, kill.1, more.1 (too outdated translation),
  fdformat.1, mcopy.1, mdel.1, mdir.1, mformat.1, mmd.1, mrd.1, mread.1,
  mtools.1, pon.1, tkinfo.1, exports.5, lilo.conf.5, lilo.8 (obsolete)

## Version 0.8

*Sun Feb 27 11:15:54 CET 2011*

* Updated upstream manpages:
  manpages 3.27-1, manpages-dev 3.27-1
* New manpages:
  setresuid.2, socketpair.2, environ.7, halt.8, shutdown.8, runlevel.8,
  sdiff.1
* Updated many translations
* Removed manpages:
  doshell.1 (upstream does no longer exist),
  g77.1 (upstream does no longer exist),
  ginstall.1 (upstream does no longer exist)

## Version 0.7

*Thu Nov 11 17:04:01 CET 2010*

* Updated and reviewed numerous manpages
* Fix typo in cut.1. Closes: [#602816](https://bugs.debian.org/602816).
* Changed cdrecord.1 to wodim.1. Closes:
  [LP#321674](https://launchpad.net/bugs/602816)

## Version 0.6

*Sat Sep 25 10:11:45 CEST 2010*

* Add a warning to outdated manpages
* Install compressed manpages by default
* Support $(DESTDIR) for installation
* Rename target "remove" to "uninstall"
* Include automatically generated manpages from GNU coreutils
* Remove manpages which contain only links
* Convert from ISO-8859-1 to UTF-8
* Remove egrep.1, will be linked to grep.1
* Rename fs.5 to filesystems.5
* Move complex.5 to complex.7 and ipc.5 to svipc.7
* Import many spelling fixes from Debian
* Add GPL-3 because of coreutils manpages
* Remove apropos.1, man.1, manpath.1, whatis.1, zsoelim.1, manpath.5,
  catman.8, and mandb.8. Those are included in the package man-db.
* Remove chsh.1, login.1, newgrp.1, passwd.1, su.1, passwd.5. Those are
  included in the packages login and passwd.
* Rename iso_8859_1.7 to iso_8859-1.7
* Remove obsolete manpages: compress.1, lunetIX.1, modules.2, obsolete.2,
  profil.2, setregid.2, sigblock.2, sigvec.2, undocumented.2, drem.3,
  infnan.3, isinf.3, killpg.3, labs.3, ldiv.3, readv.3, hisax.7
* Move sigpause.2 to sigpause.3
* Move fifo.4 to fifo.7

## Version 0.5

*Mon Nov 27 15:02:04 CET 2006*

* New wprintf(3) by Walter Harms
* New bstring(3) by Walter Harms
* New tzselect(8) by Peter Littmann
* New clearenv(3) by Daniel Kobras
* Updates to environ(7), getenv(3), putenv(3) and setenv(3) by Daniel Kobras
* Updates to atexit(3) by Erik Meusel
* New getresuid(2) and setresuid(2) by Dennis Stampfer
* Updates to cdrecord(1) by Jens Seidel
* Updates to fstab(5) by Jens Seidel
* New asprintf(3) by David Thamm
* Many corrections by Jens Seidel
* Updates to tzset(3) by Joey Schulze
* More corrections by Jens Seidel
* Updates to find(1) by Peter Niederlag and Joey Schulze
* Updates to LDP(7) by Joey Schulze
* Correction to usleep(2) by Erik Thiele
* New bsearch(3) and complex(5) by Jens Rohler
* New cimag(3) and creal(3) by Maik Messerschmidt
* New cabs(3) by Jens Rohler

## Version 0.4

*Tue Jan  1 20:27:33 CET 2002*

* Added fileutils manpages, converted by Michael Piefel
* Added updated tar(1) by Michael Piefel
* Updated printf(3), ioctl(2), ioctl_list(2) and stat(2) by Michael Piefel
* Added resolver(5) and full(4) by Martin Schmitt
* Added diff(1) and tar(1) by Michael Piefel
* Added utf-8(7) and socket(2) by Sebastian Rittau
* Added shellutils manpages, converted by Michael Piefel
* Added info(1), converted by Michael Piefel
* Added tkinfo(1) by Michael Piefel
* Updates to atoi(3) by Michael Piefel
* Added capget(2), chdir(2), chmod(2) and clone(2) by Daniel Kobras
* Updates to write(1) by Daniel Kobras
* Updates to mkdir(2) by Daniel Kobras
* Added host.conf(5) by Martin Schmitt
* Updates to select(2) by Daniel Kobras
* Updates to comm(1) by Daniel Kobras
* New passwd(1) by Michael Piefel
* Updates to clock(3) by Michael Piefel
* Updates to strftime(3) by Michael Piefel
* New dysize(3) and getdate(3) by Walter Harms
* Updates to comm(1) and install(1) by Michael Piefel (help2man)
* New rpc(5) by Martin Schulze
* Updates to read(2) by Peter Gerbrandt
* New lseek(2) by Peter Gerbrandt
* Mostly new getdate(3) by Martin Schulze
* New undocumented(3) by Michael Arndt
* New rmdir(2) by Michael Arndt
* New LDP(7) by Walter Holzer
* New tzset(3) by Walter Harms
* New isdnlog(5) by Holger Jannsen and me

## Version 0.3

*Sun Jan 21 21:29:46 CET 2001*

* Added assert.3, translated by Toni Volkmer
* Added cdrecord.1 translated by Eduard Bloch
* Added hypot.3 translated by Regine Bast
* Added alloca.3,chroot.2,j0.3,re_comp.3,shmop.2,time.2,vm86.2,
  assert.3,close.2,mem.4,outb.2,shmget.2,swapon.2,times.2 by
  Ralf Demmer.
* Added getpapersize.2,erf.3,ffs.3 translated by Regine Bast
* Added chown.2 translated by Florian Jenn
* Added unlink.2 translated by Joern Verhoff
* Added difftime.3 translated by Jens Pueschel
* Moved environ.5 to environ.7
* Added new translation to ps(1) by Martin Schulze
* Updated cdrecord.1
* Added errno(3) by Christoph Seibert
* Added init(8) and rdev(8) by Martin Okrslar
* Added exec(3), ferror(3), memchr(3), setbuf(3) by Roland Krause
* Added getpass(3) and initgroups(3) by Andreas D. Preissig
* Added atexit(3), byteorder(3), ctermid(3), ctime(3), fseek(3), getopt(3),
  sigsetops(3) and string(3) by Patrick Rother
* Added crypt(3) by Martin Schulze
* Updated suffixes(7) by Michael Piefel
* Added fifo(4) by Martin Schmitt
* Added hosts(5) by Florian Jenn

## Version 0.2

*Tue Mar 16 09:42:55 CET 1999*

* Added scanf.3, translated by Patrick Rother
* Added floor.3, translated by Martin Schulze
* Changed syntax of some manpages, Andreas Braukmann
* New group.5 motd.5 proc.5 shells.5 ttytype.5 pages from Mike Fengler
* New hisax.7 page from Soeren Todt
* Updated email address from Markus Kaufmann
* New environ.5 fs.5 ipc.5 services.5 termcap.5  from Mike Fengler
* Added manpath.1 zsoelim.1 manpath.5 catman.8 mandb.8 by Anke Steuernagel
  and Nils Magnus
* New apropos.1 man.1 whatis.1 by Anke Steuernagel and Nils Magnus
* Added more names to COPYRIGHTs file
* Added pon/poff/plog.1 from Othmar Pasteka
* Added locale.7 translated by Joey
* Added binkd.8 translated by Andreas Braukmann
* Added fgetc(3)
* Added newline for getsid(2) and strcpy(3)
* New snapshot, includes
  * Corrections made by Johnny Tevessen <j.tevessen@line.org>
  * New unicode.7 from Johnny Tevessen <j.tevessen@line.org>
  * localeconf.5 updated by Jochen Hein
  * Fixed spelling errors in ls.1, nohup.1, mmap.1, msync.2,
    localeconf.3, puts.3, fstab.5, issue.5, man.config.5, securetty.6,
    intro.6, man.7
  * un-undocumented in section 2: msync, readv, writev, getsid, _sysctl
* New upstream pages included
* Merged README and readme
* Removed manpages for man,apropos,whatis} (fixes: [Bug#5335](https://bugs.debian.org/5335))
* Corrected man(7) (fixes: [Bug#10327](https://bugs.debian.org/10327))
* Corrected nohup(1) (fixes: [Bug#10873](https://bugs.debian.org/10873))

## Version 0.1

* First collection, made by Andries Brouwer
