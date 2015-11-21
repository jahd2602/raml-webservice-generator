var util = require('util');

exports.parse = function (schemaString) {

    try {
        return typeof schemaString !== 'object' ? JSON.parse(schemaString) : schemaString;
    } catch (e) {
        console.log(e);
        return {
            properties: {}
        };
    }

};

/**
 * @param schemas will be updated with missing schemas
 * @returns {{}} all the schemas including the related schemas
 */
exports.relations = function (schemas) {
    var relations = {};
    Object.keys(schemas).forEach(function (schemaName) {

            var schema = exports.parse(schemas[schemaName]);

            Object.keys(schema.properties).forEach(function (name) {

                var property = schema.properties[name];
                if (property.type === 'array' && property.items) {

                    if (!Array.isArray(property.items)) {
                        property.items = [property.items];
                    }

                    property.items.forEach(function (item) {

                            var relSchema;
                            var relSchemaExist = true;
                            var relSchemaName;

                            if (item.ref && schemas.hasOwnProperty(item.ref)) {
                                relSchema = schemas[item.ref];
                                relSchemaName = item.ref;
                                relSchemaExist = true;
                            } else if (schemas.hasOwnProperty(item.name)) {
                                relSchemaName = item.name;
                                relSchema = schemas[item.name];
                                relSchemaExist = true;
                            } else {
                                relSchemaName = item.name;
                                relSchema = JSON.stringify(item);
                                relSchemaExist = false;
                            }

                            var relSchemaDetailsName = util.format('%s_%s', schemaName, relSchemaName);

                            relations[relSchemaDetailsName] = {
                                parent: {
                                    schema: schema,
                                    name: schemaName
                                },
                                child: {
                                    schema: relSchema ? exports.parse(relSchema) : null,
                                    name: relSchemaName,
                                    exist: relSchemaExist
                                },
                                item: item
                            };

                        }
                    )
                    ;

                }

            });

        }
    );

    // Add missing children schemas to base schema
    Object.keys(relations).forEach(function (relationName) {

        var relation = relations[relationName];
        if (!schemas[relation.child.name]) {
            schemas[relation.child.name] = relation.child.schema;
        }

    });
    return relations;
};

exports.cleanPrimaryProperties = function (propertyOld, schemaNameOld) {

    var propertyRel = {};
    var property = Object.clone(propertyOld, true);
    var schemaName = Object.clone(schemaNameOld, true);

    if (property && typeof property === 'object') {

        Object.keys(property).forEach(function (propertyName) {
            delete property[propertyName].primary;
            delete property[propertyName].unique;
            delete property[propertyName].uniqueItems;
            delete property[propertyName].autoIncrement;

            property[propertyName].name = schemaName;
            property[propertyName].ref = schemaName;
            property[propertyName].type = 'object';
            propertyRel[schemaName] = property[propertyName];
        });
    }

    return propertyRel;
};
