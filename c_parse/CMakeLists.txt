
INCLUDE_DIRECTORIES(${CMAKE_SOURCE_DIR}/src/parse/)
INCLUDE_DIRECTORIES(${CMAKE_BINARY_DIR}/src/parse/)

ADD_EXECUTABLE(parse_gen_hash parse-gen-hash.c) 
TARGET_LINK_LIBRARIES(parse_gen_hash glib-2.0)
TARGET_LINK_LIBRARIES(parse_gen_hash proxy-util)



ADD_CUSTOM_COMMAND(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/parse-hash.h
  COMMAND ${CMAKE_RUNTIME_OUTPUT_DIRECTORY}/parse_gen_hash > ${CMAKE_BINARY_DIR}/src/parse/parse-hash.h
  DEPENDS parse_gen_hash 
)


ADD_CUSTOM_COMMAND( 
    OUTPUT parse-yacc.c parse-yacc.h 
    COMMAND bison  -y -p proxy_ --output=parse-yacc.c --defines=parse-yacc.h ${CMAKE_SOURCE_DIR}/src/parse/parse-yacc.y 
    DEPENDS  ${CMAKE_SOURCE_DIR}/src/parse/parse-yacc.y)

ADD_CUSTOM_TARGET( GenServerSource DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/parse-hash.h)

SET(parse_sources parse-lex.c parse-charset.c parse-yacc.c)

ADD_LIBRARY(proxy-parse STATIC ${parse_sources})
TARGET_LINK_LIBRARIES(proxy-parse  proxy-util dbug glib-2.0)
ADD_DEPENDENCIES(proxy-parse GenServerSource)

ADD_EXECUTABLE(parsetest test-parse.c)
TARGET_LINK_LIBRARIES(parsetest proxy-parse glib-2.0)

ADD_EXECUTABLE(parsetree parse-tree.c)
TARGET_LINK_LIBRARIES(parsetree proxy-parse glib-2.0)

#INSTALL(TARGETS proxy-parse ARCHIVE DESTINATION lib/)

#INSTALL(TARGETS parse_gen_hash parsetest parsetree RUNTIME DESTINATION bin/)
