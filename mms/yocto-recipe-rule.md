recipe:
```bitbake
SUMMARY = !!FixMe!!
DESCRIPTION = !!FixMe!!
SECTION = "PLATFORM"
LICENSE = "CLOSED"

SRC_URI = "file://sources"

# Change base directory for make
S = "${WORKDIR}/sources"

# require default paths
require conf/galileo-env.inc

FILES_${PN} += "\
"

FILES_${PN}-dev += "\
"

FILES_${PN}-staticdev += "\
"

# build depends
DEPENDS += ""
# runtime depends
RDEPENDS_${PN} += ""

do_install() {
    !!FixMe!!
        install -d ${D}/${GALILEO_INC}
            install -m 0755 ${S}/include/lo.h ${D}/${GALILEO_INC}
                install -m 0755 ${S}/include/lo_def.h ${D}/${GALILEO_INC}

                    install -d ${D}/${GALILEO_APP_PUBLIC_LIB}
                        install -m 0755 ${B}/libgalileo_lo.so ${D}/${GALILEO_APP_PUBLIC_LIB}

                            # TODO: Remove this
                                install -d ${D}/${GALILEO_PF_LIB}
                                    install -m 0755 ${B}/libgalileo_lo.so ${D}/${GALILEO_PF_LIB}
}
```

makefile:
```make
# Target file name.
TARGET ?= !!FixMe!!
# Add according to directory structure.
SRC_DIRS ?= ./src
INC_DIRS ?= ./include

# Basic compiler options.
# DESCRIPTION: Please add according to the needs of building objects.
# ................................................................
# Pre-processor option (sharing option for c and c++).
CPPFLAGS += $(INC_FLAGS) -MMD -MP -O2 -Wall -Wextra -pedantic \
    -Wno-missing-field-initializers -g3
# C compiler option.
    CFLAGS   +=
# C++ compiler option.
    CXXFLAGS += -std=c++11
# Linker option.
    LDFLAGS  +=
# Set dependent librarys.
# Add neccessary library options. eg. -lpthread
    LDLIBS   += !!FixMe!!

##################################################################
# From this line onwards is the basic settings.
# Please understand how work by comment. Don't use not understand.
##################################################################

# Finding source files, and set objects filelist and dependent filelist
# by $(SRC_DIRS).
# ................................................................
SRCS :=$(shell find $(SRC_DIRS) -name *.cpp -or -name *.c -or -name *.s)
OBJS :=$(addsuffix .o,$(basename $(SRCS)))
DEPS :=$(OBJS:.o=.d)

# Automatic specification of local include directory by $(INC_DIR).
# ................................................................
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# Make for shared object options.
# When "lib * .so" (* is a wild card) is set for $(TARGET)
# add build option for shared object.
# ................................................................
ifneq (,$(filter lib%.so,$(TARGET)))
    # Pre-processor option (sharing option for c and c++).
        CPPFLAGS += -fPIC
            # C compiler option.
                CFLAGS   +=
                    # C++ compiler option.
                        CXXFLAGS +=
                            # Linkser Option.
                                LDFLAGS += -shared -Wl,-no-as-needed -Wl,-soname,$(TARGET)
                                endif

# Decide the last link command.
# If C++ files are included, use $(CXX) as the last link command otherwise
# use $(CC).
# ................................................................
CPPSUFFIXS=%.cpp %.cc %.cxx
ifeq (0,$(words $(foreach suffix,$(CPPSUFFIXS),$(filter $(suffix),$(SRCS)))))
    COMPILER=$(CC)
    else
            COMPILER=$(CXX)
            endif

# General build rule.
# Since we use implicit make rules, we only define the last
# link rule and clean rule.
# ................................................................

.PHONY: all clean

all:$(TARGET)

$(TARGET):$(OBJS)
        $(COMPILER) $(LDFLAGS) $(OBJS) -o $@ $(LOADLIBES) $(LDLIBS)

        clean:
                $(RM) $(OBJS) $(TARGET) $(DEPS)

                -include $(DEPS)
```

directory:
```
|-- galileo-ps-0.1
|   |-- sources
|   |   |-- Makefile ... 前述のMakefile
|   |   |-- include　... package外部、公開用ヘッダdirectory
|   |   `-- src           ... ソースコード/package内部ヘッダ
|   `-- utest
|       |-- Makefile ... 必要であれば単体テストMakefile(要請あれば公開します)
|       `-- src         ... テストコード
|-- galileo-ps-utest_0.1.bb ... 必要であれば単体テストレシピ(要請あれば公開します)
`-- galileo-ps_0.1.bb    ... 前述のレシピ
```
